extends Line2D

@export var number_of_points := 100
@export var frequency : float = 200.0
@export var length_multiplier := 15.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var array := []
	
	for i in range(number_of_points):
		array.append(Vector2(
			200 + i * length_multiplier,
			200 + sin(i) * frequency
		))
