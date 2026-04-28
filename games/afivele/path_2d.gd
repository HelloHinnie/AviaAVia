extends Path2D

@onready var path_follow = $PathFollow2D
var dragging = false
var start_position: Vector2 = Vector2.ZERO


func _input(event):
	# Detecta o toque inicial no objeto (ou na tela)
	if event is InputEventScreenTouch:
		if event.pressed:
			dragging = true
		else:
			dragging = false

	# Movimentação
	if event is InputEventScreenDrag and dragging:
		update_position(event.position)
	else:
		event.position = start_position

func update_position(touch_pos: Vector2):
	# 1. Converte a posição global do toque para a posição local do Path
	var local_pos = to_local(touch_pos)
	
	# 2. Encontra o ponto mais próximo na curva em relação ao toque
	var offset = curve.get_closest_offset(local_pos)
	
	# 3. Aplica o offset ao PathFollow2D para mover o objeto
	path_follow.progress = offset
