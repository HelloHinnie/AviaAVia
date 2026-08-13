extends Node2D

const TRANSITION_SCENE: PackedScene = preload("res://main/UI/TransitionPage/TransitionPaper.tscn")

var _transition_layer: CanvasLayer = null

func _ready() -> void:
	# Cria a camada de transição e adiciona à raiz da cena
	_transition_layer = TRANSITION_SCENE.instantiate()
	get_tree().root.add_child.call_deferred(_transition_layer)

func _on_start_2_pressed() -> void:
	print("pressionado começar")
	if _transition_layer:
		_transition_layer.transition_to("res://games/aperte_os_cintos/AperteOsCintos.tscn")
	pass # Replace with function body.

func _on_quit_2_pressed() -> void:
	print("pressionado sair")
	get_tree().quit()
	pass # Replace with function body.
