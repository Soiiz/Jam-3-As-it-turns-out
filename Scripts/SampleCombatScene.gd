extends Node2D

export (float) var timeBetweenActions = .4

onready var myTextLabel : RichTextLabel = get_node("DebugText")
onready var myButton : Button = get_node("Button")
onready var myAnimator : AnimationPlayer = get_node("AnimationPlayer")
onready var myPlayerCharacter = get_node("BulletHell/Player")
onready var myBulletHell = get_node("BulletHell")
onready var myWallAnimator : AnimationPlayer = get_node("BulletHellAnimator")

var myHealth := 100;


var rizzActive := false;

var opponentHealth := 0; # want to get to 100
var opponent_current_want = "Gift" #"Compliment" "Gift" "Flirt"

func change_want()->void:
	var temp = rand_range(1,3)
	match temp:
		1 : opponent_current_want = "Gift";
		2 : opponent_current_want = "Compliment";
		3 : opponent_current_want = "Flirt"; 

var turnCounter = 1;




var currentState = "wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction -> ... repeat
var actionQueue = []

# stats
export (int) var playerSpeed = 100
export (int) var sodaSpeed = 150
export (int) var shieldHP = 50



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
			turnCounter += 1;
			
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
	
func enemyActionEnd()->void:
	myPlayerCharacter.tweenTo(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2 ), 1.0)
	myBulletHell.hide()
	myBulletHell.player_speed = playerSpeed
	myBulletHell.shield = 0
	myPlayerCharacter.setInputAllowed(false)
	myWallAnimator.play_backwards("WallsMoveIn")
	rizzActive = false;
	
	
func add_action(_toAdd):
	actionQueue.push_back(_toAdd)
	
func _on_Button_pressed() -> void:
	next_phase()
	pass # Replace with function body.
	
#need implementing
#wingman1
func action_vibecheck():
	#dialogue pop up showing that current thing
	print(opponent_current_want);
	pass
func action_rizz():
	rizzActive = true;
	pass
func action_soda():
	myBulletHell.player_speed = sodaSpeed
#wingman2
func action_rumor():
	opponentHealth += 3;
	pass
func action_console():
	myHealth += 10
	if myHealth > 100:
		myHealth = 100;
	pass
func action_protect():
	print("protect")
	myBulletHell.shield = shieldHP
#player
func action_compliment():
	if opponent_current_want == "Compliment": #"Compliment" "Gift" "Flirt"
		opponentHealth += 3;
	opponentHealth += 2
	if rizzActive:
		opponentHealth += 4
	pass
func action_flirt():
	if opponent_current_want == "Flirt": #"Compliment" "Gift" "Flirt"
		opponentHealth += 3;
	opponentHealth += 2
	if rizzActive:
		opponentHealth += 4
	pass
func action_gift():
	if opponent_current_want == "Gift": #"Compliment" "Gift" "Flirt"
		opponentHealth += 3;
	opponentHealth += 2
	if rizzActive:
		opponentHealth += 4
	pass
