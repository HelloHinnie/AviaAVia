extends Line2D

class_name Cinto
@onready var cinto_presilha: Area2D = $Cinto_Presilha
@onready var cinto_passador: Area2D = $Cinto_Passador

@export var Pa_Position: Vector2 = Vector2.ZERO
@export var Pe_Position: Vector2 = Vector2.ZERO
@export var Tamanho: Vector2 = Vector2.ONE

var Locked: bool = false

func _ready() -> void:
	cinto_presilha.scale = Tamanho
	cinto_passador.scale = Tamanho
	width = width * abs(Tamanho.x)
	pass
