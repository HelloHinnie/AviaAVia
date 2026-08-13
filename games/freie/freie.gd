extends Node2D
@onready var character_body_2d: CharacterBody2D = $CharacterBody2D
@export var win = false	
@onready var end_timer: Timer = $EndTimer
@export var title : String
@export var desc : String
@onready var timer: Timer = $Timer

signal send_results(win : bool) 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	if character_body_2d.velocity.x == 0:
		win = true
		send_results.emit(win)
	pass

func _on_area_2d_area_entered(_area: Area2D) -> void:
	print("entrou")
	win = false
	$Timer.stop()
	send_results.emit(win)
	pass 

func _on_timer_timeout() -> void:
	win = false
	send_results.emit(win)
	pass
