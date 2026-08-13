extends Node2D

@export var win = false
signal send_results(win : bool) 
@onready var path_2d: Path2D = $Path2D
@export var title : String
@export var desc : String
@onready var timer: Timer = $Timer

@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var area_2d: Area2D = $Path2D/PathFollow2D/Area2D
@onready var sprite_2d: Sprite2D = $Path2D/PathFollow2D/Sprite2D
@onready var line_2d: Line2D = $Path2D/Line2D

var dragging = false
var minigame_complete = false
var cached_curve_points: PackedVector2Array

func _ready():
	cached_curve_points = path_2d.curve.get_baked_points()
	
	# Configura o Line2D
	line_2d.z_index = -1
	line_2d.visible = true
	line_2d.points = PackedVector2Array()  # Começa vazio
	
	area_2d.input_event.connect(_on_area_2d_input_event)

func _input(event):
	# Se soltar o clique/toque em QUALQUER lugar da tela, para o arrasto
	if event is InputEventScreenTouch and not event.pressed:
		dragging = false
		if not minigame_complete:
				path_follow.progress_ratio = 0.0
				draw_trail()
	
	# Se estiver arrastando, atualiza a posição
	if event is InputEventScreenDrag and dragging and not minigame_complete:
		update_position(event.position)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	# Detecta se o primeiro toque aconteceu EXATAMENTE em cima da fivela
	if event is InputEventScreenTouch and event.pressed:
		dragging = true

func update_position(touch_pos: Vector2):
	var local_pos = path_2d.to_local(touch_pos)
	var offset = path_2d.curve.get_closest_offset(local_pos)
	

	path_follow.progress = offset
	
	draw_trail()
	
	if path_follow.progress_ratio >= 0.98: # 98% para dar uma margem de erro suave
		complete_minigame()

func draw_trail():
	if cached_curve_points.size() < 2: 
		return
	
	var max_points = cached_curve_points.size()
	var points_to_draw_count = int(max_points * path_follow.progress_ratio)
	
	# Se não tem pontos para desenhar, limpa a linha
	if points_to_draw_count < 1:
		line_2d.points = PackedVector2Array()
		return
	
	var points_to_draw = cached_curve_points.slice(0, points_to_draw_count)
	line_2d.points = points_to_draw
	
func complete_minigame():
	dragging = false
	path_follow.progress_ratio = 1.0 
	sprite_2d.hide()
	draw_trail()
	win = true
	send_results.emit(win)

func _on_timer_timeout() -> void:
	win = false
	send_results.emit(win)
	pass
