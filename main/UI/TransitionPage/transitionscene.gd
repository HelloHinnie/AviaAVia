extends Node2D

#@export var pedrinha_scene: PackedScene # Arraste a cena da pedrinha para cá no Inspector
var timer_gerador: Timer
const PREDA = preload("uid://c8ytnyu8ayyv3")

func _ready():
	# Cria um Timer via código para spawnar as pedras
	timer_gerador = Timer.new()
	timer_gerador.wait_time = 0.3 # Nasce uma pedra a cada 0.15 segundos
	timer_gerador.timeout.connect(_on_timer_timeout)
	add_child(timer_gerador)
	timer_gerador.start()

func _on_timer_timeout():
	if PREDA == null:
		return
		
	var nova_pedrinha = PREDA.instantiate()
	$Chao.add_sibling(nova_pedrinha) 
	
	# Espalha o nascimento das pedras por uma área muito mais larga embaixo!
	# Teste valores como 200 a 1080 para ver o que se encaixa melhor na largura da sua estrada
	var pos_x_aleatoria = randf_range(300.0, 980.0)
	
	nova_pedrinha.iniciar(pos_x_aleatoria)
