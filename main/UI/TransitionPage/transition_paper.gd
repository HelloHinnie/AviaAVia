extends CanvasLayer

## Gerencia transições entre cenas usando TransitionPaper com chroma key duplo.
## Verde → cena atual (transparente via shader discard)
## Azul → cena seguinte (renderizada no SubViewport)
## Uso: TransitionPaper.transition_to("res://caminho/da/cena.tscn")

var _target_scene: String = ""
var _transitioning: bool = false
var _callable_after: Callable = Callable()
var _next_scene_instance: Node = null
var _viewport_texture_set: bool = false

const MAX_LOOPS: int = 1

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var sub_viewport: SubViewport = $SubViewport


func _ready() -> void:
	hide()


func transition_to(scene_path: String, after: Callable = Callable()) -> void:
	if _transitioning:
		push_warning("TransitionPaper: já está em transição.")
		return
	
	_transitioning = true
	_target_scene = scene_path
	_callable_after = after
	_viewport_texture_set = false
	
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	
	# Configura o SubViewport com a cena seguinte
	_setup_next_scene_viewport(scene_path, viewport_size)
	
	# Ajusta escala e posição do sprite para cobrir a tela
	var texture_size: Vector2 = Vector2(1920, 1080)
	animated_sprite.position = viewport_size / 2.0
	animated_sprite.scale = Vector2(
		viewport_size.x / texture_size.x,
		viewport_size.y / texture_size.y
	)
	
	# Conecta frame_changed para atualizar textura do shader
	if not animated_sprite.frame_changed.is_connected(_on_frame_changed):
		animated_sprite.frame_changed.connect(_on_frame_changed)
	
	# MUDANÇA: Conecta animation_finished ao invés de animation_looped
	if not animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.connect(_on_animation_finished)
	
	animated_sprite.speed_scale = 0.5
	animated_sprite.play("default")
	show()
	
	# Agenda atualização da textura do SubViewport para o próximo frame
	get_tree().process_frame.connect(_update_shader_texture, CONNECT_ONE_SHOT)


func _setup_next_scene_viewport(scene_path: String, vp_size: Vector2) -> void:
	sub_viewport.size = Vector2i(vp_size)
	_cleanup_next_scene()
	
	var packed_scene: PackedScene = load(scene_path)
	_next_scene_instance = packed_scene.instantiate()
	_next_scene_instance.process_mode = Node.PROCESS_MODE_DISABLED
	sub_viewport.add_child(_next_scene_instance)
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_ONCE


func _update_shader_texture() -> void:
	animated_sprite.material.set_shader_parameter(
		"next_scene",
		sub_viewport.get_texture()
	)
	_viewport_texture_set = true


func _on_frame_changed() -> void:
	# Força render do SubViewport enquanto a animação toca
	if _viewport_texture_set:
		sub_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS


# Renomeada de _on_animation_looped para _on_animation_finished
func _on_animation_finished() -> void:
	# IMPORTANTE: Não use animated_sprite.stop() aqui.
	# Como o Loop foi desativado, a animação vai parar naturalmente no último frame.
	
	sub_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	
	if animated_sprite.animation_finished.is_connected(_on_animation_finished):
		animated_sprite.animation_finished.disconnect(_on_animation_finished)
	
	if animated_sprite.frame_changed.is_connected(_on_frame_changed):
		animated_sprite.frame_changed.disconnect(_on_frame_changed)
	
	if _callable_after.is_valid():
		_callable_after.call()
	
	if not _target_scene.is_empty():
		# O último frame azul vai ficar na tela perfeitamente durante esse delay
		var timer: SceneTreeTimer = get_tree().create_timer(0.1)
		timer.timeout.connect(_change_scene)


func _change_scene() -> void:
	# Esconde o overlay ANTES de trocar de cena para evitar
	# que o frame atual (com sprite parado) apareça por 1 frame
	hide()
	get_tree().change_scene_to_file(_target_scene)
	# Agenda reset após a troca
	get_tree().process_frame.connect(_reset, CONNECT_ONE_SHOT)


func _reset() -> void:
	hide()
	_transitioning = false
	_target_scene = ""
	_callable_after = Callable()
	_viewport_texture_set = false
	_cleanup_next_scene()


func _cleanup_next_scene() -> void:
	if _next_scene_instance:
		_next_scene_instance.queue_free()
		_next_scene_instance = null
	
	for child in sub_viewport.get_children():
		if not child is Camera2D:
			child.queue_free()
