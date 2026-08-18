extends Node2D

@export var win = false
signal send_results(win : bool) 
@export var title : String
@export var desc : String

@export var drag_necessario : float = 10000
var limpeza_acumulada : float = 0.0

# Referências
@onready var parabrisa_esq: Sprite2D = $ParabrisaEsq
@onready var parabrisa_dir: Sprite2D = $ParabrisaDir
@onready var sujo: Sprite2D = $sujo

# Configurações do Limpador
@export var angulo_min_graus : float = -80.0 # Até onde o limpador desce (ajuste para o seu sprite)
@export var angulo_max_graus : float = 80.0  # Até onde ele sobe
@export var sensibilidade : float = 0.1      # Velocidade que o limpador acompanha o dedo
var rotacao_atual_graus : float = -80.0      # Posição inicial

var esfregando = false
var jogo_ganho = false

func _ready():
	# Força a posição inicial dos limpadores ao abrir o jogo
	atualizar_parabrisas()

func _input(event):
	# Se soltar a tela/mouse, para de interagir
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if not event.pressed:
			esfregando = false

# Lembre-se de conectar o sinal input_event do Area2D nesta função!
func _on_area_vidro_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if jogo_ganho:
		return
		
	# Tocou na tela
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			esfregando = true
			
	# Arrastou o dedo
	if esfregando and (event is InputEventScreenDrag or event is InputEventMouseMotion):
		# Guarda a posição do limpador antes de mover
		var rotacao_anterior = rotacao_atual_graus
		
		# Movemos a rotação com base no movimento do dedo na tela (eixo X)
		rotacao_atual_graus += event.relative.x * sensibilidade
		
		# Impede que o limpador dê um giro de 360 graus, travando-o nos limites
		rotacao_atual_graus = clamp(rotacao_atual_graus, angulo_min_graus, angulo_max_graus)
		
		# Calcula o quanto o limpador REALMENTE se moveu (em graus)
		# Se ele bateu no limite (ex: não pode passar de 10 graus), ele não soma limpeza
		var movimento_real = abs(rotacao_atual_graus - rotacao_anterior)
		
		if movimento_real > 0:
			# Multiplicamos o movimento_real para dar um ritmo legal à barra de limpeza
			limpeza_acumulada += movimento_real * 10 
			
			atualizar_parabrisas()
			atualizar_limpeza()

func atualizar_parabrisas():
	# Godot usa radianos para rotação, então convertemos nossos graus para radianos
	var rotacao_rad = deg_to_rad(rotacao_atual_graus)
	parabrisa_esq.rotation = rotacao_rad
	parabrisa_dir.rotation = rotacao_rad

func atualizar_limpeza():
	var proporcao = 1.0 - (limpeza_acumulada / drag_necessario)
	proporcao = clamp(proporcao, 0.0, 1.0)
	
	sujo.modulate.a = proporcao
	
	if limpeza_acumulada >= drag_necessario and not jogo_ganho:
		jogo_ganho = true
		venceu_minigame()

func venceu_minigame():
	send_results.emit(true)
	$Timer.stop()
