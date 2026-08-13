extends CharacterBody2D
@export var velocidade : float = -600.0
@export var forca_do_freio : float = 400.0 # Quanto menor, mais o carro desliza (maior inércia)
@onready var animal: Sprite2D = $"../animal"
@onready var freio: Sprite2D = $"../freio"

var freiando = false

func _ready():
	velocity.x = velocidade

func _physics_process(delta):
	if freiando:
		velocity.x = move_toward(velocity.x, 0, forca_do_freio * delta)
	move_and_slide()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventScreenTouch and event.pressed:
		freiando = true
