extends Node2D

const CARRO_NPC = preload("res://games/acompanha_o_transito/carro_npc.tscn")

@onready var carro_jogador = $CharacterBody2D
@onready var sprite_freio: Sprite2D = $freio
@onready var area_freio: Area2D = $freio/Area2D

@onready var sprite_acelerador: Sprite2D = $acelerador if has_node("acelerador") else null
@onready var area_acelerador: Area2D = $acelerador/Area2D if has_node("acelerador/Area2D") else null
@onready var timer_jogo: Timer = $Timer

@export var title : String
@export var desc : String

var carros_npcs: Array = []
var timer_ciclo: Timer
var jogo_encerrado: bool = false

signal send_results(win: bool)

func _ready() -> void:
	carro_jogador.position = Vector2(600, 448)
	carro_jogador.add_to_group("jogador")
	
	_instanciar_npc(Vector2(1100, 448))
	_instanciar_npc(Vector2(150, 448))
	
	timer_ciclo = Timer.new()
	timer_ciclo.wait_time = 1.2
	timer_ciclo.autostart = true
	timer_ciclo.timeout.connect(_on_alternar_transito)
	add_child(timer_ciclo)
	
	if timer_jogo:
		timer_jogo.timeout.connect(_on_tempo_esgotado)
	
	area_freio.input_event.connect(_on_freio_input_event)
	if area_acelerador:
		area_acelerador.input_event.connect(_on_acelerador_input_event)

func _instanciar_npc(posicao: Vector2) -> void:
	var npc = CARRO_NPC.instantiate()
	npc.position = posicao
	add_child(npc)
	carros_npcs.append(npc)

func _on_alternar_transito() -> void:
	if jogo_encerrado: return
	var novo_estado = not carros_npcs[0].em_movimento
	for npc in carros_npcs:
		npc.em_movimento = novo_estado
	timer_ciclo.wait_time = randf_range(1.0, 1.8)

# Uso das funções set do jogador para evitar erros de tipo
func _on_freio_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		carro_jogador.set_freiando(event.pressed)
		if sprite_freio:
			sprite_freio.scale = Vector2(0.8, 0.8) if event.pressed else Vector2(0.95, 0.95)

func _on_acelerador_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		carro_jogador.set_acelerando(event.pressed)
		if sprite_acelerador:
			sprite_acelerador.scale = Vector2(0.8, 0.8) if event.pressed else Vector2(0.95, 0.95)

func finalizar_jogo(vitoria: bool) -> void:
	if jogo_encerrado: return
	jogo_encerrado = true
	
	timer_ciclo.stop()
	if timer_jogo:
		timer_jogo.stop()
		
	carre_parar_tudo()
	
	print("Fim de Jogo. Vitória: ", vitoria)
	emit_signal("send_results", vitoria)

func carre_parar_tudo() -> void:
	carro_jogador.set_physics_process(false)
	for npc in carros_npcs:
		if is_instance_valid(npc):
			npc.set_physics_process(false)

func perder_jogo() -> void:
	finalizar_jogo(false)

func _on_tempo_esgotado() -> void:
	finalizar_jogo(true)
