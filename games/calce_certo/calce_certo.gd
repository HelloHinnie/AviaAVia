extends Node2D

const ShoeScene = preload("res://games/calce_certo/shoe.tscn")
var shoes = []

@export var shoe_timer : float = 1.0
@export var shoe_density : float = 0.4


@export var min_spacing : float = 200
@export var max_spacing : float = 200

var right_shoes = [0, 2, 4]
var wrong_shoes = [1, 3, 5]

var cell_count : int = 6
var cell_range : float
var cell_length : float

const window_size = Vector2(1152, 720)
var location = Vector2()


var predefined_positions = [
	Vector2(836, 360), # 1. Direita
	Vector2(706, 585), # 2. Inferior Direito
	Vector2(446, 585), # 3. Inferior Esquerdo
	Vector2(316, 360), # 4. Esquerda
	Vector2(446, 135), # 5. Superior Esquerdo
	Vector2(706, 135)  # 6. Superior Direito
]

func _ready() -> void:

	spawn_shoes(6)

func spawn_shoes(amount: int):
	# Duplica a array e embaralha para escolhermos pontos aleatórios sem repetir
	var chosen_positions = predefined_positions.duplicate()
	chosen_positions.shuffle()
	
	for i in range(amount):
		var instance = ShoeScene.instantiate()
		instance.frame = i
		# Pega a posição na array embaralhada
		instance.position = chosen_positions[i]
		
		# Adiciona o sapato à cena
		add_child(instance)

func rand_zero_one() -> float:
	var rng = RandomNumberGenerator.new()
	return rng.randf_range(0.0, 1.0)

func get_shoe_center(center: Vector2) -> Vector2:
	var r = 48 * sqrt(rand_zero_one())
	var theta = rand_zero_one() * 2 * PI

	return center + r*Vector2(cos(theta), sin(theta))

#func spawn_shoes():
	#var chosen_centers = grid_centers
	##chose 12 out of 15 from grid centers
#
	#for c in chosen_centers:
		#var instance = ShoeScene.instantiate()
		##var corner = enemy.boss_arena.global_position - Vector2(240, 136)
		#instance.global_position = get_shoe_center(c)
		#add_child(instance)
		##enemy.get_parent().add_child(instance) 
#
#
#func _ready() -> void:
	## Define o tamanho da área central onde os sapatos podem aparecer
	#var center_area_size = Vector2(600, 400) 
	#var screen_center = window_size / 2.0
	#
	## Calcula os limites dessa área com base no centro da tela
	#var min_x = screen_center.x - (center_area_size.x / 2.0)
	#var max_x = screen_center.x + (center_area_size.x / 2.0)
	#var min_y = screen_center.y - (center_area_size.y / 2.0)
	#var max_y = screen_center.y + (center_area_size.y / 2.0)
	#
	#var min_distance = 230 # Distância mínima entre cada sapato (ajuste conforme o tamanho do sprite)
	#var spawned_positions = [] # Guarda onde já tem sapato
	#
	#var shoes_to_spawn = 5
	#var spawned_count = 0
	#var attempts = 0 # Previne loops infinitos se não houver espaço
	#
	#while spawned_count < shoes_to_spawn and attempts < 100:
		#attempts += 1
		#
		## 1. Gera uma posição candidata dentro da área central
		#var candidate_pos = Vector2(
			#randf_range(min_x, max_x),
			#randf_range(min_y, max_y)
		#)
		#
		## 2. Verifica se a candidata está longe o suficiente de todos os sapatos já instanciados
		#var is_valid = true
		#for pos in spawned_positions:
			#if candidate_pos.distance_to(pos) < min_distance:
				#is_valid = false
				#break # Já achou um muito perto, cancela a verificação
		#
		## 3. Se passou no teste, cria o sapato!
		#if is_valid:
			#var instance = ShoeScene.instantiate()
			#instance.position = candidate_pos
			#add_child(instance)
			#
			#spawned_positions.append(candidate_pos)
			#spawned_count += 1
	#var start_x : float = 192.0 
	#var end_x : float = 1152.0 

	#var available_width = end_x - start_x
	#var cell_length = available_width / cell_count
	#
	#for i in range(0, cell_count):
		#var shoe_clone = shoe.duplicate()
		#add_child(shoe_clone)
		#shoes.append(shoe_clone) 
		#
		#var cell_start_x = start_x + (cell_length * i)
		#
		#var padding = 20.0 
		#var final_x = cell_start_x + randf_range(padding, cell_length - padding)
		#
		#var final_y = randi_range(128, 448)
		#
		#shoe_clone.position = Vector2(final_x, final_y)
		#
		#if randi_range(0,1) == 0:
			#shoe_clone.flip_h = true
			
		#shoe_clone.frame = i
	#shoe.hide()
pass

#func _process(delta: float) -> void:
	### Start two looping tweens, one for positions, one for bumbling
	##var position_tween = create_tween().set_loops()
	##position_tween.tween_callback(tween_shoe_positions).set_delay(shoe_timer)
	##
	##var bumble_tween = create_tween().set_loops()
	##bumble_tween.tween_callback(tween_shoe_bumble).set_delay(0.1)
#pass
