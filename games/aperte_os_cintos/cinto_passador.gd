extends Node2D

@onready var line_2d: Line2D = $".."
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cinto_presilha: Area2D = $"../Cinto_Presilha"

var start_position: Vector2 = Vector2.ZERO
var dragging := false
var touch_offset := Vector2.ZERO
var travado := false

func _ready() -> void:
	start_position = position
	line_2d.set_point_position(0, position)
	line_2d.set_point_position(1, position)
	position = start_position

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed and not travado:
		touch_offset = position - event.position
		dragging = true


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not event.pressed:
		dragging = false
		if not travado:
			position = start_position
			line_2d.set_point_position(1, start_position)

	if event is InputEventScreenDrag and dragging and not travado:
		position = event.position + touch_offset
		line_2d.set_point_position(1, position)

func _on_cinto_presilha_area_entered(area: Area2D) -> void:
	if area == self:
		travado = true
		dragging = false
		position = cinto_presilha.position
		line_2d.set_point_position(1, position)
