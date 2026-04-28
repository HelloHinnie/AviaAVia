extends AnimatedSprite2D

var tween1
var tween2

# Called when the node enters the scene tree for the first time.
func _ready():
	first_tween()

func first_tween():
	tween1 = create_tween()
	tween1.tween_property(self, "rotation", deg_to_rad(-25), 0.5).set_trans(Tween.EASE_IN_OUT)
	tween1.tween_callback(second_tween)

func second_tween():
	tween2 = create_tween()
	tween2.tween_property(self, "rotation", deg_to_rad(25), 0.5).set_trans(Tween.EASE_IN_OUT)
	tween2.tween_callback(first_tween)
