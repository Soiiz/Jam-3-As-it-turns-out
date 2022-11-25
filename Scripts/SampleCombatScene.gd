extends Node2D


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
		"exeuctingQueue":
			currentState = "enemyAction"
			enemyActionStart()
		"enemyAction":
			currentState = "wingman1"
			myAnimator.play("SceneAnimations");
			enemyActionEnd()
			
	myTextLabel.text = String(currentState) + "\n" + String(actionQueue);
	
	
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
