extends MicroGame

func checkLocked():
	for child in get_children():
		if child is Cinto and not child.Locked:
			pass
	game_cleared()
