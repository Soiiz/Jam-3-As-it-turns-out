extends Node2D

export (float) var timeBetweenActions = .4;

onready var myTextLabel : RichTextLabel = get_node("DebugText")
onready var myButton : Button = get_node("Button")
onready var myAnimator : AnimationPlayer = get_node("AnimationPlayer")
onready var myPlayerCharacter : ControllableCharacter = get_node("PlayerCharacter")
onready var myBulletHellManager = get_node("BulletHell/BulletManager");
onready var myWallAnimator : AnimationPlayer = get_node("BulletHellAnimator")

var currentState = "wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction -> ... repeat
var actionQueue = []


func _ready() -> void:
	myAnimator.play("SceneAnimations");
	myBulletHellManager.firingEnabled = false;
	myPlayerCharacter.setInputAllowed(false);
	
func next_phase() -> void:
	match currentState:
		"wingman1":
			currentState = "wingman2"
			myAnimator.play("Wingman1->2");
		"wingman2":
			currentState = "player"
			myAnimator.play("Wingman2->Player");
		"player":
			currentState = "exeuctingQueue"
			executeQueue();
		"exeuctingQueue":
			currentState = "enemyAction"
			enemyActionStart()
		"enemyAction":
			currentState = "wingman1"
			myAnimator.play("SceneAnimations");
			enemyActionEnd()
			
	myTextLabel.text = String(currentState) + "\n" + String(actionQueue);
	
	
func executeQueue():
	for action in actionQueue:
		var currAction = actionQueue.front()
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
		yield(get_tree().create_timer(timeBetweenActions),"timeout");
	next_phase()
	
	
func enemyActionStart() -> void:
	myBulletHellManager.firingEnabled = true;
	myPlayerCharacter.setInputAllowed(true);
	myWallAnimator.play("WallsMoveIn");
	
func enemyActionEnd()->void:
	myPlayerCharacter.tweenTo(Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2 ), 1.0);
	myBulletHellManager.firingEnabled = false;
	myPlayerCharacter.setInputAllowed(false);
	myWallAnimator.play_backwards("WallsMoveIn")
	
	
func add_action(_toAdd):
	actionQueue.push_back(_toAdd);
	
func _on_Button_pressed() -> void:
	next_phase()
	pass # Replace with function body.
	
#need implementing
#wingman1
func action_vibecheck():
	pass
func action_rizz():
	pass
func action_soda():
	pass
#wingman2
func action_rumor():
	pass
func action_console():
	pass
func action_protect():
	pass
#player
func action_compliment():
	pass
func action_flirt():
	pass
func action_gift():
	pass
