extends Node

@export var win = false
@onready var end_timer: Timer = $EndTimer
@export var title : String
@export var desc : String
signal send_results(win : bool)

var cintos_afivelados: int = 0
var total_cintos: int = 5

func _ready():
	var lista_cintos = [$Cinto, $Cinto2, $Cinto3, $Cinto4, $Cinto5]
	
	for i in lista_cintos:
		var passador = i.get_node("Cinto_Passador")
		passador.encaixado.connect(_on_cinto_encaixado)

func _on_cinto_encaixado():
	cintos_afivelados += 1
	if cintos_afivelados >= total_cintos:
		win = true
		$Timer.stop()
		end_timer.start()
	
func _on_timer_timeout():
	win = false
	send_results.emit(win)
	
func _on_end_timer_timeout() -> void:
	send_results.emit(win)
	pass 
