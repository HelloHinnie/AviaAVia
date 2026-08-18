extends Area2D

@export var base_speed: float = 30.0 
@export var drag_sensitivity: float = 0.4 

var is_dragging: bool = false

func _process(delta: float) -> void:
	# Movimento autônomo constante da direita para a esquerda
	position.x -= base_speed * delta

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
	elif event is InputEventScreenTouch:
		if event.pressed:
			is_dragging = true

func _input(event: InputEvent) -> void:
	if is_dragging:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			is_dragging = false
		elif event is InputEventScreenTouch and not event.pressed:
			is_dragging = false
			
		if event is InputEventMouseMotion or event is InputEventScreenDrag:
			# Trava para aceitar APENAS movimento para a ESQUERDA (valores negativos)
			if event.relative.x < 0:
				# Soma o valor (que já é negativo), movendo para a esquerda
				position.x += (event.relative.x * drag_sensitivity)
