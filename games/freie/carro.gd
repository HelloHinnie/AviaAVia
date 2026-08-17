extends CharacterBody2D
@export var velocidade : float = -600.0
@export var forca_do_freio : float = 400.0 # Quanto menor, mais o carro desliza (maior inércia)
@onready var animal: Sprite2D = $"../animal"
@onready var freio: Sprite2D = $"../freio"
@export var fator_de_rotacao : float = 0.015
@onready var roda1: Sprite2D = $Sprite2D/roda1
@onready var roda2: Sprite2D = $Sprite2D/roda2
var freiando = false

func _ready():
	velocity.x = velocidade

func _physics_process(delta):
	if freiando:
		velocity.x = move_toward(velocity.x, 0, forca_do_freio * delta)
		freio.scale = Vector2(0.8, 0.8)
	else:
		freio.scale = Vector2(1, 1)
	move_and_slide()
	var rotacao_atual = velocity.x * fator_de_rotacao * delta
	roda1.rotation += rotacao_atual
	roda2.rotation += rotacao_atual

# 1. Esta função é da Area2D. Ela só serve para APERTAR o freio.
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	# Checa tanto toque na tela quanto clique do mouse (para testes no PC)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			freiando = true

# 2. Esta função é do próprio Godot. Ela serve para SOLTAR o freio.
func _input(event: InputEvent) -> void:
	# Checa tanto toque na tela quanto clique do mouse
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		# Se a ação foi "soltar" (not pressed), o freio é desativado
		if not event.pressed:
			freiando = false
