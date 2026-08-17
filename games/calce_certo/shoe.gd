extends AnimatedSprite2D

signal clicked
var selected = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_pressed() -> void:
	selected = not selected
	self.material.set_shader_parameter("onoff", int(selected))
	clicked.emit()
	pass # Replace with function body.
