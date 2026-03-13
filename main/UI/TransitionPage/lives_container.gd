extends Control
@onready var lives_container: HBoxContainer = $LivesContainer

var lives: int:
	get:
		return lives
	set(value):
		lives = value
		if lives_container.get_child_count() == lives:
			return
		for child in lives_container.get_children():
			lives_container.remove_child(child)
		for i in lives:
			var life = life_scene.instantiate()
			lives_container.add_child(life)
