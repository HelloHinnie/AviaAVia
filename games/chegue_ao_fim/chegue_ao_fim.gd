extends Node2D

@onready var timer: Timer = $Timer
var jogo_ativo: bool = true

func _ready() -> void:
	# Inicia o timer da fase (ex: 6 segundos)
	timer.wait_time = 6.0
	timer.one_shot = true
	timer.start()
	timer.timeout.connect(_on_tempo_esgotado)

func _on_tempo_esgotado() -> void:
	if jogo_ativo:
		# Se o tempo acabou e o jogador não bateu nem chegou, decide se venceu ou perdeu
		ganhar_jogo()

func ganhar_jogo() -> void:
	if not jogo_ativo: return
	jogo_ativo = false
	print("Good Job! (Vitória)")
	# Carrega a próxima fase ou tela de vitória
