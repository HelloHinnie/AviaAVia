extends Path2D

@onready var path_follow = $PathFollow2D
@onready var area_2d: Area2D = $PathFollow2D/Area2D
@onready var line_2d: Line2D = $"Line2D"
@onready var sprite_2d: Sprite2D = $PathFollow2D/Sprite2D

var dragging = false
var minigame_complete = false
# Cache para os pontos da curva (performance)
var cached_curve_points: PackedVector2Array

func _ready():
	cached_curve_points = curve.get_baked_points()
	
	# Configura o Line2D
	line_2d.z_index = -1
	line_2d.visible = true
	line_2d.points = PackedVector2Array()  # Começa vazio
	
	area_2d.input_event.connect(_on_area_2d_input_event)

func _unhandled_input(event):
	# Se soltar o clique/toque em QUALQUER lugar da tela, para o arrasto
	if event is InputEventScreenTouch and not event.pressed:
		dragging = false
	
	# Se estiver arrastando, atualiza a posição
	if event is InputEventScreenDrag and dragging and not minigame_complete:
		update_position(event.position)

func _on_area_2d_input_event(_viewport, event, _shape_idx):
	# Detecta se o primeiro toque aconteceu EXATAMENTE em cima da fivela
	if event is InputEventScreenTouch and event.pressed:
		dragging = true

func update_position(touch_pos: Vector2):
	var local_pos = to_local(touch_pos)
	var offset = curve.get_closest_offset(local_pos)
	
	# Atualiza a posição física da fivela
	path_follow.progress = offset
	
	# NOVO: Desenha a linha até a posição atual
	draw_trail()
	
	# Verifica se chegou ao fim (Fivela fechada)
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
	
	# Print para debug: olhe o console lá embaixo no Godot quando você arrastar
	# print("Desenhando linha com ", points_to_draw.size(), " pontos")

func complete_minigame():
	dragging = false
	minigame_complete = true
	path_follow.progress_ratio = 1.0 
	sprite_2d.hide()
	# Garante que a linha desenhe até o final absoluto
	draw_trail() 
	
	
	print("Capacete fechado com sucesso!")
	# Aqui você ativa sua animação de sucesso ou muda de cena
