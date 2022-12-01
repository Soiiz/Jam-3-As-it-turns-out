extends Node2D

export (float) var timeBetweenActions = .4

onready var myTextLabel : RichTextLabel = get_node("DebugText")
onready var myButton : Button = get_node("Button")
onready var myAnimator : AnimationPlayer = get_node("AnimationPlayer")
onready var myPlayerCharacter = get_node("BulletHell/Player")
onready var myBulletHell = get_node("BulletHell")
onready var myWallAnimator : AnimationPlayer = get_node("BulletHellAnimator")

var currentState = "wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction -> ... repeat
var actionQueue = []

# stats
export (int) var playerSpeed = 100
export (int) var sodaSpeed = 150
export (int) var shieldHP = 50
export (float) var timeInSHMUP = 3.0

func _ready() -> void:
	myAnimator.play("SceneAnimations")
	myBulletHell.hide()
	myBulletHell.shield = 0
	myBulletHell.player_speed = playerSpeed
	myPlayerCharacter.setInputAllowed(false)
	
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
		var currAction = actionQueue.pop_front()
		#match actions to function calls
		match currAction:
			"VibeCheck": action_vibecheck()
			"Rizz" : action_rizz()
			"Soda" : action_soda()
			"GoodRumor" : action_rumor()
			"Console" : action_console()
			"Protect" : action_protect()
			"Compliment" : action_compliment()
			"Flirt" : action_flirt()
			"Gift" : action_gift()
		yield(get_tree().create_timer(timeBetweenActions),"timeout")
	next_phase()
	
	
func enemyActionStart() -> void:
	myBulletHell.show()
	myPlayerCharacter.setInputAllowed(true)
	myWallAnimator.play("WallsMoveIn")
	yield(get_tree().create_timer(timeInSHMUP),"timeout")
	next_phase()
	
func enemyActionEnd()->void:
	myPlayerCharacter.tweenTo(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2 ), 1.0)
	myBulletHell.hide()
	myBulletHell.player_speed = playerSpeed
	myBulletHell.shield = 0
	myPlayerCharacter.setInputAllowed(false)
	myWallAnimator.play_backwards("WallsMoveIn")

	
	
func add_action(_toAdd):
	actionQueue.push_back(_toAdd)
	
func _on_Button_pressed() -> void:
	next_phase()
	pass # Replace with function body.
	
#need implementing
#wingman1
func action_vibecheck():
	
	print("vibecheck")
func action_rizz():
	print("rizz")
func action_soda():
	myBulletHell.player_speed = sodaSpeed
#wingman2
func action_rumor():

	print("rumor")
func action_console():
	print("console")
func action_protect():
	myBulletHell.shield = shieldHP
#player
func action_compliment():
	print("compliment")
func action_flirt():
	print("flirt")
func action_gift():
	print("gift")
