extends AnimatedSprite2D

var tween1
var tween2

# Called when the node enters the scene tree for the first time.
func _ready():
	first_tween()

func first_tween():
	tween1 = create_tween()
	tween1.tween_property(self, "position:y", position.y+10, 0.1)
	tween1.tween_callback(second_tween)

func second_tween():
	tween2 = create_tween()
	tween2.tween_property(self, "position:y", position.y-10, 0.1)
	tween2.tween_callback(first_tween)
