extends Line2D

@export var timer: Timer
@onready var fogo: AnimatedSprite2D = $"Fogo"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.set_point_position(1, Vector2(remap(timer.time_left, timer.wait_time, 0, 1280, 0),0))
	fogo.position = Vector2(remap(timer.time_left, timer.wait_time, 0, 1280, 0), -48)
	if timer.time_left == 0:
		fogo.hide()
