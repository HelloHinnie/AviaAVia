extends CharacterBody2D

@export var velocidade_alvo : float = -350.0
@export var aceleracao : float = 500.0
var em_movimento : bool = false # Variável que estava faltando no script do NPC

func _ready() -> void:
	add_to_group("npcs") # Essencial para reconhecer a colisão com o jogador

func _physics_process(delta: float) -> void:
	if em_movimento:
		velocity.x = move_toward(velocity.x, velocidade_alvo, aceleracao * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, 800 * delta)
		
	move_and_slide()
