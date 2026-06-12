extends MicroGame

@export var win = false

signal send_results(win : bool) 

var afivelado = 0;

func checkLocked():
	afivelado += 1;
	if afivelado == 5:
		win = true
		send_results.emit(win)
	
func _on_timer_timeout():
	win = false
	send_results.emit(win)
