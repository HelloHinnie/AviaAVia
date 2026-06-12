extends ColorRect

@onready var timer: Timer = $"../Timer"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	self.size.x = remap(timer.time_left, timer.wait_time, 0, 1280, 0)
	self.color.h = remap(timer.time_left, timer.wait_time, 0, 0.37, 0)
