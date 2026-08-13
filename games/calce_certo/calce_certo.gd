extends Node2D

@onready var shoe: AnimatedSprite2D = $Shoe
var shoes = []

@export var shoe_timer : float = 1.0
@export var shoe_density : float = 0.4


@export var min_spacing : float = 200
@export var max_spacing : float = 200

var right_shoes = [0, 2, 4]
var wrong_shoes = [1, 3, 5]

var cell_count : int = 6
var cell_range : float
var cell_length : float

func _ready() -> void:
	#var start_x : float = 192.0 
	#var end_x : float = 1152.0 

	#var available_width = end_x - start_x
	#var cell_length = available_width / cell_count
	#
	#for i in range(0, cell_count):
		#var shoe_clone = shoe.duplicate()
		#add_child(shoe_clone)
		#shoes.append(shoe_clone) 
		#
		#var cell_start_x = start_x + (cell_length * i)
		#
		#var padding = 20.0 
		#var final_x = cell_start_x + randf_range(padding, cell_length - padding)
		#
		#var final_y = randi_range(128, 448)
		#
		#shoe_clone.position = Vector2(final_x, final_y)
		#
		#if randi_range(0,1) == 0:
			#shoe_clone.flip_h = true
			
		#shoe_clone.frame = i
	#shoe.hide()
 	pass

func _process(delta: float) -> void:
	## Start two looping tweens, one for positions, one for bumbling
	#var position_tween = create_tween().set_loops()
	#position_tween.tween_callback(tween_shoe_positions).set_delay(shoe_timer)
	#
	#var bumble_tween = create_tween().set_loops()
	#bumble_tween.tween_callback(tween_shoe_bumble).set_delay(0.1)
	pass
