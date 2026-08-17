extends Node2D

# Win/lose phrases
var winPhrase = [
	"MUITO BEM!"
]
var losePhrase = [
	"AH NÃO!"
]

#Lives
var lives
var score : int = 0
var games_played : int = 0
@onready var lives_text: RichTextLabel = $"Text Layer/Lives Text"
@onready var lives_icon: AnimatedSprite2D = $"Text Layer/Lives Text/Lives Container/Lives Holder/Lives Icon"
@onready var lives_container: BoxContainer = $"Text Layer/Lives Text/Lives Container"
@onready var lives_holder: Control = $"Text Layer/Lives Text/Lives Container/Lives Holder"
@onready var speed_text: RichTextLabel = $"Text Layer/Speed Text"
@onready var game_over_text: RichTextLabel = $"Text Layer/Game Over Text"

@onready var scoreText: RichTextLabel = $"Text Layer/Score Text"

#Shaders
@onready var speed_lines: ColorRect = $"Shaders/SpeedLines"
@onready var blurShader: ColorRect = $Shaders/Blur
@onready var greyShader: ColorRect = $Shaders/Greyed

var livesTween
var scoreTween
var speedTween

#Moto
@onready var motoca: AnimatedSprite2D = $"Transition Layer/Motoca"

# Speed related stuff
@export var timerMultiplier : float = 1.0
var speedCounter = 0
var speedEvery = Global.speedEvery

#Timers
@onready var beginning_timer: Timer = $"Beginning Timer"
@onready var starting_timer: Timer = $"Starting Timer"
@onready var ending_timer: Timer = $"Ending Timer"
@onready var transition_timer: Timer = $"Transition Timer"

#Title Text
@onready var title_text: RichTextLabel = $"Text Layer/titleText"
@onready var text_animator: AnimationPlayer = $"Text Layer/Text Animator"

# List of games in play
var gameList : Array
var gamesLeft : Array

var gameOvered = false

# Next game, current game, last game
var nextScene
var currentGame
var lastGame

#Botões de pause e info
@onready var button_layer: CanvasLayer = $"Button Layer"
@onready var info_button: TextureButton = $"Button Layer"/InfoButton
@onready var pause_button: TextureButton = $"Button Layer"/PauseButton

@onready var pause_layer: CanvasLayer = $"Pause Layer"
@onready var info_layer: CanvasLayer = $"Info Layer"
@onready var desc_game: RichTextLabel = $"Info Layer/ColorRect/TextBox/DescGame"


func _ready() -> void:
	
	# Set the list of games - Now handled in global variables!
	gameList = Global.currentGameList.duplicate()
	if gameList.is_empty():
		gameList = load("res://Resources/Playlists/ALL.tres").games
	
	gamesLeft = gameList.duplicate()
	
	#Velocidade dos jogos
	timerMultiplier *= Global.timerMultiplier
	set_speed(timerMultiplier)
	
	# If the speed_every is zero, change it to the playlist size
	if speedEvery == 0:
		speedEvery = gameList.size()
	
	#Lives/Score
	lives = Global.startingLives
	
	lives_text.text = "[right][color=#00000000]99 x    "
	scoreText.text = "[left]SCORE: " + str(score)
	
	#Ícones de vida 
	lives_icon.frame = 0
	var lives_icon_frame : int = randi_range(0,lives_icon.sprite_frames.get_frame_count("default"))
	lives_icon.frame = lives_icon_frame
	#livesShadow.frame = lives_icon_frame
	
	#Fazer 5 ícones de vida
	for i in range(1,5):
		lives_container.add_child(lives_holder.duplicate())
		lives_container.get_child(i).visible = false
	
	#Se você tiver mais que 5 vidas
	if lives > 5:
		lives_text.text = "[right]%s x     " % str(lives)
	else:
		for i in range(1, lives):
			lives_container.get_child(i).visible = true
		
	displayScore("show")
	
	## Logo
	#logo.scale = Vector2(0,0)
	#displayLogo("show")
	#
	## Transition backgrounds
	#transitionBackgrounds = get_tree().get_nodes_in_group("transitionBackgrounds")
	#transitionBack
	#Misturar jogos
	
	gamesLeft.shuffle()
	
	## But first, make sure certain games don't appear early
	#if gamesLeft.size() > 3:
		#for i in range(0,4):
			#if gamesLeft[i] in Global.non_early_games:
				#gamesLeft.insert(randi_range(4,gamesLeft.size()-1), gamesLeft[i])
				#gamesLeft.remove_at(i)
	
	nextScene = load(gamesLeft[0]).instantiate()
	
	if gamesLeft.size() > 1:
		ResourceLoader.load_threaded_request(gamesLeft[1])
	
	pass # Replace with function body.

func _on_beginning_timer_timeout():
	starting_timer.start()

func _on_starting_timer_timeout():
	#Apresenta  o título do jogo
	#title_text.text = "[shake rate = 20.0 level=20][center]\n" + currentGame.title
	
	#Pausar processamento
	get_tree().paused = true
	pause_button.disabled = true
	#transitionJingle.play() # Transition jingle
	
	#Resetar shaders
	#winShader.visible = false
	greyShader.visible = false
	blurShader.visible = true
	speed_lines.visible = false
	
	#Esconder score/vidas
	
	displayScore("hide")
	#displayLogo("hide")
	#motoca.hide() #Remover depois
	
	#Se estava jogando um jogo anteriormente, limpar
	if currentGame:
		currentGame.free()
	
	#Adiciona próximo jogo como jogo atual
	get_node("/root/" + self.name + "/CurrentGame").add_child(nextScene)
	currentGame = get_node("/root/" + self.name + "/CurrentGame").get_child(0)
	currentGame.send_results.connect(_on_game_end)
	
	# And make sure the audio rate matches the current speed!
	#currentGame.get_child(0).pitch_scale = timerMultiplier
	
	# Speed up fanfare too....
	for child in currentGame.get_children():
		if child.get_name() == "Fanfare":
			for fanfare in child.get_children():
				fanfare.pitch_scale = timerMultiplier
	
	#Mostrar o título do jogo
	title_text.text = "[shake rate=20.0 level=20][center]\n\n\n" + currentGame.title
	text_animator.play("FadeZoomIn")
	
	
	transition_timer.start()
	#animator.play("FadeOut")


func _on_transition_timer_timeout() -> void:
	text_animator.play("FadeZoomOut") # Transition out title
	blurShader.visible = false # Get rid of blur!
	get_tree().paused = false # Unpause the minigame!
	pause_button.disabled = false
	button_layer.show()
	#currentGame.get_child(0).play() # Play the music! GOD THIS IS STUPID
	
	currentGame.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# If you have negative (infinite) lives, pause the mingame timer
	if lives < 0:
		currentGame.timer.paused = true
	pass 

func _on_game_end(win):
	# Do stuff upon winning or losing!
	button_layer.hide()
	if win:
		score += 1
		scoreText.text = "[left]SCORE: " + str(score)
		#winJingle.play()
		title_text.text = "[shake rate=20.0 level=20][center]\n\n\n" + winPhrase.pick_random()
		#winShader.visible = true
	else:
		if lives >= 0:
			lives -= 1
			if lives > 5:
				lives_text.text = "[right]%s x    " % str(lives)
			elif lives == 5:
				lives_text.text = "[right][color=#00000000]99 x    "
				for i in range(1,lives):
					lives_container.get_child(i).visible = true
			else:
				lives_container.get_child(lives).queue_free()
			#lives_text.text = "[right]LIVES: " + str(lives)
		#loseJingle.play()
		title_text.text = "[shake rate=20.0 level=20][center]\n\n\n" + losePhrase.pick_random()
		greyShader.visible = true
	
	# Increment games played
	games_played += 1
	
	# Set attribute text back to blank!
	#attributeText.text = "[center]"
	
	# Transition
	#chooseTransition()
	text_animator.play("FadeZoomIn")
	
	# Pause the mingames again
	get_tree().paused = true
	
	# If you've run out of lives, make time normal
	#if lives == 0:
		#set_speed(1.0)
	
	# Give a bit of time before ending the game
	ending_timer.start()
	
	# Load next minigame
	lastGame = gamesLeft[0] # Check what the last played game was
	gamesLeft.pop_front()
	
	# Check the list of games to see if we need to refill/reshuffle it
	if gamesLeft.size() > 0:
		nextScene = ResourceLoader.load_threaded_request(gamesLeft[0])
		if gamesLeft.size() > 1:
			ResourceLoader.load_threaded_request(gamesLeft[1])
	else:
		gamesLeft = gameList.duplicate()
		gamesLeft.shuffle()
		while gamesLeft[0] == lastGame and gamesLeft.size() > 1:
			gamesLeft.shuffle()
		ResourceLoader.load_threaded_request(gamesLeft[0])
		if gamesLeft.size() > 1:
			ResourceLoader.load_threaded_request(gamesLeft[1])

func _on_ending_timer_timeout() -> void:
	# Win or lose we're transitioning
	text_animator.play("FadeZoomOut")
	#animator.play("FadeIn")
	
	if lives != 0: # If you still have lives (or have negative ((infinite)) lives)
		#startJingle.play()
		starting_timer.start()
		displayScore("show")
		#displayLogo("show")
		
		nextScene = ResourceLoader.load_threaded_get(gamesLeft[0]).instantiate()
		nextScene.process_mode = Node.PROCESS_MODE_DISABLED
		
		# Only speed up game if threshold is positive
		if speedEvery >= 0:
			# Speed up the game when the speed counter reaches the threshold
			speedCounter += 1
			if speedCounter >= speedEvery:
				increase_speed()
				speedCounter = 0
	else:
		gameOver()
	pass # Replace with function body.
	
func increase_speed():
	# Increase speed
	timerMultiplier += (1.0/12.0)
	
	# Speed up/slow down game based on timer multiplier
	Engine.time_scale = timerMultiplier
	
	# Show the speed up text
	speedTween = create_tween()
	speedTween.tween_property(speed_text, "position", Vector2(speed_text.position.x,620), 0.5).set_trans(Tween.TRANS_BACK)
	speedTween.tween_property(speed_text, "position", Vector2(speed_text.position.x,620), 1.5).set_trans(Tween.TRANS_BACK)
	speedTween.tween_property(speed_text, "position", Vector2(speed_text.position.x,740), 0.5).set_trans(Tween.TRANS_BACK)
	
	# Speed up transition jingles
	#winJingle.pitch_scale = timerMultiplier
	#loseJingle.pitch_scale = timerMultiplier
	#transitionJingle.pitch_scale = timerMultiplier
	#startJingle.pitch_scale = timerMultiplier

func set_speed(speed : float):
	timerMultiplier = speed
	
	# Speed up/slow down game based on timer multiplier
	Engine.time_scale = timerMultiplier
	
	# Speed up transition jingles
	#winJingle.pitch_scale = timerMultiplier
	#loseJingle.pitch_scale = timerMultiplier
	#transitionJingle.pitch_scale = timerMultiplier
	#startJingle.pitch_scale = timerMultiplier

func displayScore(mode : String):
	scoreTween = create_tween()
	if lives >= 0:
		livesTween = create_tween()
	if mode == "show":
		scoreTween.tween_property(scoreText, "position", Vector2(64,64), 0.5).set_trans(Tween.TRANS_BACK)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,64), 0.5).set_trans(Tween.TRANS_BACK)
	elif mode == "hide":
		scoreTween.tween_property(scoreText, "position", Vector2(64,-120), 0.5).set_trans(Tween.TRANS_BACK)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,-120), 0.5).set_trans(Tween.TRANS_BACK)
	elif mode == "final":
		scoreTween.tween_property(scoreText, "position", Vector2(64,580), 2).set_trans(Tween.TRANS_ELASTIC)
		if lives >= 0:
			livesTween.tween_property(lives_text, "position", Vector2(0,580), 2).set_trans(Tween.TRANS_ELASTIC)

#func chooseTransition():
	#for i in range(0, transitionBackgrounds.size()):
		#if i == 0:
			#transitionBackgrounds[i].visible = true
		#else:
			#transitionBackgrounds[i].visible = false
	#
	#transitionBackgrounds.push_back(transitionBackgrounds.pop_front())

func gameOver():
	# Free up the last game
	currentGame.free()
	
	# UNPAUSE THE FUCKING SCENE TREE GOD I'M SO STUPID
	get_tree().paused = false
	
	# Continue on as if this wasn't an issue that took an hour to solve...
	#gameOverTheme.play()
	
	game_over_text.text = "[center]GAME OVER\n[font_size=60](ESC) to go back to menu\n(SPACE) to retry"
	lives_text.text = "[right]%s\n[font_size=40](%s)" % [Global.playlistName, Global.difficultyName]
	
	displayScore("final")
	
	### MINIGAME SPECIFIC ##
	## Clear out used passwords
	#GlobalVariables.usedPasswords = []
	#
	## Clear out used gamertags
	#GlobalVariables.usedUsernames = []
	#
	## Hamster phrases
	#GlobalVariables.kindPhrases = []
	#
	## Therapy answers
	#GlobalVariables.therapyNotes = []
	### MINIGAME SPECIFIC ##
	
	# visual elements
	var gameOverTween = create_tween()
	gameOverTween.tween_property(game_over_text, "position", Vector2(game_over_text.position.x,180), 2).set_trans(Tween.TRANS_ELASTIC)
	
	#$"Transition Layer/ColorRect".visible = false
	#transition.visible = true
	
	#for i in range(0, transitionBackgrounds.size()):
		#transitionBackgrounds[i].visible = false
	
	gameOvered = true
	
	## SAVE DATA ##
	## HI-SCORE  ##
	#if GlobalVariables.difficultyName == "EASY" or GlobalVariables.difficultyName == "NORMAL":
		#if GlobalVariables.playlistName in DataSaver.player_save.hiscores.keys():
			#if score > DataSaver.player_save.hiscores[GlobalVariables.playlistName][GlobalVariables.difficultyName]:
				#DataSaver.update_hiscore(GlobalVariables.playlistName, GlobalVariables.difficultyName, score)
				#
	### CURRENCY  ##
	#if GlobalVariables.difficultyName == "EASY":
		#DataSaver.add_currency(score)
	#else:
		#DataSaver.add_currency(score*2)
		
	## LEADERBOARDS ##
	#if score > 0:
		#if GlobalVariables.difficultyName == "EASY" or GlobalVariables.difficultyName == "NORMAL":
			#if GlobalVariables.playlistName in DataSaver.player_save.hiscores.keys():
				#Steam.findLeaderboard(GlobalVariables.playlistName + "_" + GlobalVariables.difficultyName)
				#await get_tree().create_timer(0.5).timeout
				#Steam.uploadLeaderboardScore(score, true, [])


func _on_pause_button_pressed() -> void:
	#if beginning_timer.
	get_tree().paused = not get_tree().paused
	pause_layer.show()
	displayScore("show")
	

func _on_despause_pressed() -> void:
	get_tree().paused = not get_tree().paused
	pause_layer.hide()
	displayScore("hide")
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.


func _on_info_button_pressed() -> void:
	get_tree().paused = not get_tree().paused
	info_layer.show()
	desc_game.text = "[shake][center]\n" + currentGame.desc
	pass # Replace with function body.

func _on_close_info_pressed() -> void:
	print("pressionado")
	info_layer.hide()
	get_tree().paused = not get_tree().paused
	pass # Replace with function body.
