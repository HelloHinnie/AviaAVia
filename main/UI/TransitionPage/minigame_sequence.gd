extends Node2D

#Lives
var lives
@onready var lives_text: RichTextLabel = $"Lives Text"
@onready var lives_icon: AnimatedSprite2D = $"Lives Text/Lives Container/Lives Holder/Lives Icon"
@onready var lives_container: BoxContainer = $"Lives Text/Lives Container"
@onready var lives_holder: Control = $"Lives Text/Lives Container/Lives Holder"
var livesTween
var scoreTween

#Timers
@onready var beginning_timer: Timer = $"Beginning Timer"
@onready var starting_timer: Timer = $"Starting Timer"
@onready var ending_timer: Timer = $"Ending Timer"
@onready var transition_timer: Timer = $"Transition Timer"

#Title Text
@onready var title_text: RichTextLabel = $"Text Layer/titleText"

# Next game, current game, last game
var nextScene
var currentGame
var lastGame

func _on_beginning_timer_timeout() -> void:
	starting_timer.start()
	pass # Replace with function body.

func _on_starting_timer_timeout():
	#Apresenta  o título do jogo
	#title_text.text = "[shake rate = 20.0 level=20][center]\n" + currentGame.title
	displayScore("hide")
	title_text.show()
	title_text.text = "[shake rate = 20.0 level=20][center]\n" + "Aperte os Cintos!"
	transition_timer.start()


func _on_transition_timer_timeout() -> void:
	pass # Replace with function body.
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	title_text.hide()
	#Lives/Score
	lives = GlobalScene.startingLives
	
	lives_text.text = "[right][color=#00000000]99 x    "
	lives_icon.frame = 0
	
	for i in range(1,5):
		lives_container.add_child(lives_holder.duplicate())
		lives_container.get_child(i).visible = false
	
	if lives > 5:
		lives_text.text = "[right]%s x     " % str(lives)
	else:
		for i in range(1, lives):
			lives_container.get_child(i).visible = true
		
	displayScore("show")
	pass # Replace with function body.

func displayScore(mode : String):
	scoreTween = create_tween()
	if lives >= 0:
		livesTween = create_tween()
	if mode == "show":
		#scoreTween.tween_property(scoreText, "position", Vector2(64,64), 0.5).set_trans(Tween.TRANS_BACK)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,64), 0.5).set_trans(Tween.TRANS_BACK)
	elif mode == "hide":
		#scoreTween.tween_property(scoreText, "position", Vector2(64,-120), 0.5).set_trans(Tween.TRANS_BACK)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,-120), 0.5).set_trans(Tween.TRANS_BACK)
	elif mode == "final":
		#scoreTween.tween_property(scoreText, "position", Vector2(64,580), 2).set_trans(Tween.TRANS_ELASTIC)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,580), 2).set_trans(Tween.TRANS_ELASTIC)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
