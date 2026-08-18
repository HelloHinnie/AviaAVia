extends Node2D

@onready var game_timer: Timer = $Timer

@export var win = false
signal send_results(win : bool) 
@export var title : String
@export var desc : String

const ANIMAL_SCENE = preload("res://games/deixe_passar/animal.tscn")

# Variáveis para controlar a fila
var total_animais: int = 3
var animais_que_passaram: int = 0

signal microgame_won
signal microgame_lost

func _ready() -> void:
	game_timer.timeout.connect(_on_timer_timeout)
	
	spawn_animais()

func spawn_animais() -> void:
	var pos_inicial_x = 800 # Onde o primeiro bicho da fila nasce
	var espacamento = 350  # A distância entre um bicho e outro
	
	# Faz um loop para criar os 3 animais
	for i in range(total_animais):
		var animal_instance = ANIMAL_SCENE.instantiate()
		
		# O 'i' multiplica o espaçamento. 
		# Bicho 0: 800 + (0 * 150) = 800
		# Bicho 1: 800 + (1 * 150) = 950
		# Bicho 2: 800 + (2 * 150) = 1100 (nasce bem mais para fora da tela)
		animal_instance.position = Vector2(pos_inicial_x + (i * espacamento), 385) 
		
		var notifier = animal_instance.get_node("VisibleOnScreenNotifier2D")
		notifier.screen_exited.connect(_on_animal_screen_exited)
		
		add_child(animal_instance)

func _on_timer_timeout() -> void:
	send_results.emit(false)

func _on_animal_screen_exited() -> void:
	# Conta que mais um bicho saiu da tela
	animais_que_passaram += 1
	
	# Só emite a vitória se a quantidade que saiu for igual ao total da fila
	if animais_que_passaram == total_animais:
		game_timer.stop() 
		send_results.emit(true)
