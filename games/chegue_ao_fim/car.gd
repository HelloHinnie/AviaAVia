extends CharacterBody2D

@export var speed: float = 350.0
@export var steer_sensitivity: float = 4.0

func _physics_process(delta: float) -> void:
	var steer_input = 0.0
	
	# 1. Pega os dados do acelerômetro do celular
	var accel = Input.get_accelerometer()
	
	if accel != Vector3.ZERO:
		# Em modo paisagem (Landscape), inclinar o celular para esquerda/direita 
		# altera o eixo X do acelerômetro. Dividimos por 9.8 para normalizar a gravidade (~1.0).
		steer_input = clamp(accel.x / 9.8, -1.0, 1.0)
		
		# Nota: Dependendo de como você segura o celular, se a direção estiver invertida,
		# basta inverter o sinal: steer_input = -clamp(accel.x / 9.8, -1.0, 1.0)
	else:
		# 2. Fallback para testes no PC (Setas do Teclado ou A/D)
		steer_input = Input.get_axis("ui_left", "ui_right")
	
	# 3. Rotaciona o carro com base na inclinação
	rotation += steer_input * steer_sensitivity * delta
	
	# 4. Move o carro automaticamente para frente na direção em que ele aponta
	velocity = Vector2.UP.rotated(rotation) * speed
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		perder_jogo()

func perder_jogo() -> void:
	print("Bateu na parede!")
	set_physics_process(false)
	# Aqui você adiciona a lógica de derrota do WarioWare (som de falha, reiniciar, etc.)
