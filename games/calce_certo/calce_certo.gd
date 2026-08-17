extends Node2D

@export var win = false
signal send_results(win : bool) 
@export var title : String
@export var desc : String
@onready var timer: Timer = $Timer

const ShoeScene = preload("res://games/calce_certo/shoe.tscn")

var right_shoes = [0, 2, 4]
var wrong_shoes = [1, 3, 5]

const window_size = Vector2(1152, 720)
var location = Vector2()
var spawned_shoes = []

var predefined_positions = [
	Vector2(836, 360),
	Vector2(706, 585), 
	Vector2(446, 585), 
	Vector2(316, 360), 
	Vector2(446, 135),
	Vector2(706, 135)  
]

func _ready() -> void:
	spawn_shoes(6)

func win_condition():
	var todos_certos_selecionados = true
	var algum_errado_selecionado = false
	
	for shoe in spawned_shoes:
		if shoe.frame in right_shoes:
			if not shoe.selected:
				todos_certos_selecionados = false
				
		elif shoe.frame in wrong_shoes:
			if shoe.selected:
				algum_errado_selecionado = true

	if todos_certos_selecionados and not algum_errado_selecionado:
		win = true
		send_results.emit(true)
		$Timer.stop()

func spawn_shoes(amount: int):
	var chosen_positions = predefined_positions.duplicate()
	chosen_positions.shuffle()
	
	for i in range(amount):
		var instance = ShoeScene.instantiate()
		instance.frame = i
		instance.position = chosen_positions[i]
		
		add_child(instance)
		spawned_shoes.append(instance)
		
		instance.clicked.connect(win_condition)


func _on_timer_timeout() -> void:
	win = false
	send_results.emit(false)
	pass # Replace with function body.
