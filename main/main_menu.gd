extends Node2D

func _on_start_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main/UI/TransitionPage/minigameSequence.tscn")
	pass # Replace with function body.

func _on_quit_2_pressed() -> void:
	print("pressionado sair")
	get_tree().quit()
	pass # Replace with function body.
