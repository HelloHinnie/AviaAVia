class_name MicroGame
extends Node

var hint_string
var game_name
var game_ended = false
var game_player = null
var game_speed = 1
var difficulty = 0
var time = 3
var Win_on_timeout = false

func get_hint_string():
	return hint_string
	
func set_hint_string(s):
	hint_string = s

func game_loss():
	pass

func game_cleared():
	if game_player != null:
		game_player.won_micro_game = true
	pass

func force_microgame_end():
	pass
	
func play_loss_sfx():
	pass
