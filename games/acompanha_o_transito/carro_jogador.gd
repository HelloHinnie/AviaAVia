extends CharacterBody2D

@export var aceleracao : float = 700.0
@export var forca_do_freio : float = 900.0
@export var velocidade_maxima : float = -450.0

var acelerando : bool = false
var freiando : bool = false

@onready var roda1: Sprite2D = $Sprite2D/roda1
@onready var roda2: Sprite2D = $Sprite2D/roda2

func _ready() -> void:
	velocity.x = 0.0 # Começa parado

# Funções auxiliares chamadas pela cena principal para evitar erros de tipo
func set_acelerando(estado: bool) -> void:
	acelerando = estado

func set_freiando(estado: bool) -> void:
	freiando = estado

func _physics_process(delta: float) -> void:
	if acelerando:
		velocity.x = move_toward(velocity.x, velocidade_maxima, aceleracao * delta)
	elif freiando:
		velocity.x = move_toward(velocity.x, 0, forca_do_freio * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 150 * delta)
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var colisao = get_slide_collision(i)
		var collider = colisao.get_collider()
		if collider and (collider.is_in_group("npcs") or collider.is_in_group("jogador")):
			if owner.has_method("perder_jogo"):
				owner.perder_jogo()

	var rotacao_atual = velocity.x * 0.015 * delta
	roda1.rotation += rotacao_atual
	roda2.rotation += rotacao_atual
