extends Sprite2D

var horizonte_y: float = 580.0 
var limite_inferior_y: float = 850.0 
var centro_x: float = 640.0 

func iniciar(pos_x_inicial: float):
	position = Vector2(pos_x_inicial, limite_inferior_y)
	scale = Vector2(3.0, 3.0)
	
	# O SEGREDO DO ÂNGULO DA ESTRADA:
	# 0.1 faz subir reto (sai da pista). 1.0 junta tudo num ponto só no meio.
	# Teste valores como 0.3, 0.4 ou 0.5. 
	# Aumente esse número até as pedras seguirem perfeitamente a linha diagonal do seu desenho do chão!
	var pos_x_final = lerp(pos_x_inicial, centro_x, 0.35) 
	
	var pos_final = Vector2(pos_x_final, horizonte_y)
	
	var tween = create_tween()
	tween.set_parallel(true) 
	
	var tempo_animacao = 3.5 
	
	# Anima a posição
	tween.tween_property(self, "position", pos_final, tempo_animacao).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 1. Faz a pedra diminuir até sumir completamente (escala 0.0)
	tween.tween_property(self, "scale", Vector2(0.0, 0.0), tempo_animacao).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 2. Faz a pedra ir ficando transparente (Fade Out)
	# modulate:a é o canal Alpha (Transparência) do Sprite
	tween.tween_property(self, "modulate:a", 0.0, tempo_animacao).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.chain().tween_callback(queue_free)
