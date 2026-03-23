extends Node2D

@export var cinto: Cinto
@onready var sprite_presilha: Sprite2D = $"../Cinto_Presilha/SpritePresilha"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var cinto_presilha: Area2D = $"../Cinto_Presilha"

var start_position: Vector2 = Vector2.ZERO
var dragging := false
var touch_offset := Vector2.ZERO
var travado := false


func _ready() -> void:
	start_position = cinto.Pa_Position
	cinto_presilha.global_position = cinto.Pe_Position
	global_position = start_position
	cinto.set_point_position(0, global_position)
	cinto.set_point_position(1, global_position)

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed and not travado:
		touch_offset = global_position - event.position
		dragging = true


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and not event.pressed:
		dragging = false
		if not travado:
			global_position = start_position
			cinto.set_point_position(1, start_position)

	if event is InputEventScreenDrag and dragging and not travado:
		global_position = event.position + touch_offset
		cinto.set_point_position(1, global_position)

func _on_cinto_presilha_area_entered(area: Area2D) -> void:
	if area == self:
		travado = true
		cinto.Locked = true
		dragging = false
		if cinto.Tamanho.x < 0:
			global_position = cinto_presilha.global_position - Vector2(-15, 17)
		else:
			global_position = cinto_presilha.global_position - Vector2(15, 17)
		cinto.set_point_position(1, global_position)
