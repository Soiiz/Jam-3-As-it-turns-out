extends Node2D

export (float) var timeBetweenActions = .4

onready var myTextLabel : RichTextLabel = get_node("DebugText")
onready var myButton : Button = get_node("Button")
onready var myAnimator : AnimationPlayer = get_node("AnimationPlayer")
onready var myPlayerCharacter = get_node("BulletHell/Player")
onready var myBulletHell = get_node("BulletHell")
onready var myVibeText : Label = get_node("VibeText")
onready var myVibeBox : ColorRect = get_node("VibeBox")

var currentState = "wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction -> ... repeat
var actionQueue = []

# stats
export (int) var playerSpeed = 100
export (int) var sodaSpeed = 150
export (int) var shieldHP = 50
export (float) var timeInSHMUP = 3.0
export var heal = 10

signal heal_health(heal)
signal enemy_rumor(interest_gain)
func _ready() -> void:
	myAnimator.play("SceneAnimations")
	myBulletHell.hide()
	myBulletHell.shield = 0
	myBulletHell.player_speed = playerSpeed
	myBulletHell.set_difficulty(0)
	myVibeText.hide()
	myVibeBox.hide()
	myPlayerCharacter.setInputAllowed(false)

# enemy effectives 
var turnNumber = 0
var effectiveQueue = [ 1, 1, 1, 2, 2, 2, 3, 3, 3] # premade queue of effective types
export var rumor_gain = 5
export var normal_gain = 10
export var effective_gain = 15
export var ineffective_gain = 0

# rizz variable
var rizzAction = false
var rizz = 0
	
func next_phase() -> void:
	match currentState:
		"wingman1":
			currentState = "wingman2"
			myAnimator.play("Wingman1->2")
		"wingman2":
			currentState = "player"
			myAnimator.play("Wingman2->Player")
		"player":
			currentState = "exeuctingQueue"
			executeQueue()
		"exeuctingQueue":
			currentState = "enemyAction"
			enemyActionStart()
		"enemyAction":
			currentState = "wingman1"
			myAnimator.play("SceneAnimations")
			enemyActionEnd()
			
	myTextLabel.text = String(currentState) + "\n" + String(actionQueue)
		
func executeQueue():
	for action in actionQueue:
		#match actions to function calls
		match action:
			"VibeCheck": action_vibecheck()
			"Rizz" : action_rizz()
			"Soda" : action_soda()
			"GoodRumor" : action_rumor()
			"Console" : action_console()
			"Protect" : action_protect()
			"Compliment" : action_compliment()
			"Flirt" : action_flirt()
			"Gift" : action_gift()
	if "VibeCheck" in actionQueue:
		yield(get_tree().create_timer(5),"timeout")
	actionQueue.clear()
	next_phase()
		
func enemyActionStart() -> void:
	myBulletHell.show()
	myPlayerCharacter.setInputAllowed(true)
	yield(get_tree().create_timer(timeInSHMUP),"timeout")
	next_phase()
	
func enemyActionEnd()->void:
	myPlayerCharacter.tweenTo(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2 ), 1.0)
	myBulletHell.hide()
	myBulletHell.player_speed = playerSpeed
	myBulletHell.shield = 0
	myPlayerCharacter.setInputAllowed(false)
	# set to next turn
	turnNumber += 1
	if rizzAction == true:
		rizzAction = false
		rizz = 1
	if turnNumber > 10:
		effectiveQueue.append(randi() % 3 + 1)
	myBulletHell.set_difficulty(turnNumber)

func add_action(_toAdd):
	actionQueue.push_back(_toAdd)
	
#need implementing
#wingman1 (done)
func action_vibecheck():
	# horrendous way to code this but im too lazy to do it properly
	myVibeText.show()
	myVibeBox.show()
	myVibeText.text = "Vibe Check: Love interest will be more effective next turn with "
	match effectiveQueue[turnNumber+1]:
		1: myVibeText.text += "compliment"
		2: myVibeText.text += "flirt"
		3: myVibeText.text += "gift"

	myVibeText.text += ", then "
	match effectiveQueue[turnNumber+2]:
		1: myVibeText.text += "compliment"
		2: myVibeText.text += "flirt"
		3: myVibeText.text += "gift"
	myVibeText.hide()
	myVibeBox.hide()
func action_rizz():
	rizzAction = true
func action_soda():
	myBulletHell.player_speed = sodaSpeed
#wingman2 (done)
func action_rumor():
	emit_signal("enemy_rumor", rumor_gain)
func action_console():
	emit_signal("heal_health", heal)
func action_protect():
	myBulletHell.shield = shieldHP
#player (done)
func action_compliment():
	var multiplier = 1
	if rizz == 1:
		rizz = 0
		multiplier = 2
	if effectiveQueue[turnNumber] == 1:
		emit_signal("enemy_rumor", effective_gain * multiplier)
	elif effectiveQueue[turnNumber] == 2:
		emit_signal("enemy_rumor", ineffective_gain * multiplier)
	else:
		emit_signal("enemy_rumor", normal_gain * multiplier)
func action_flirt():
	var multiplier = 1
	if rizz == 1:
		rizz = 0
		multiplier = 2
	if effectiveQueue[turnNumber] == 1:
		emit_signal("enemy_rumor", ineffective_gain * multiplier)
	elif effectiveQueue[turnNumber] == 2:
		emit_signal("enemy_rumor", effective_gain * multiplier)
	else:
		emit_signal("enemy_rumor", normal_gain * multiplier)
func action_gift():
	var multiplier = 1
	if rizz == 1:
		rizz = 0
		multiplier = 2
	if effectiveQueue[turnNumber] == 1:
		emit_signal("enemy_rumor", ineffective_gain * multiplier)
	elif effectiveQueue[turnNumber] == 2:
		emit_signal("enemy_rumor", normal_gain * multiplier)
	else:
		emit_signal("enemy_rumor", effective_gain * multiplier)


func _on_Button_pressed():
	var error = get_tree().reload_current_scene()
	if error != OK:
		print("Error reloading scene: " + str(error))
