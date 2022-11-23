extends Node2D

onready var myTextLabel : RichTextLabel = get_node("DebugText")
onready var myButton : Button = get_node("Button")
onready var myAnimator : AnimationPlayer = get_node("AnimationPlayer")
onready var myPlayerCharacter : ControllableCharacter = get_node("PlayerCharacter")

var currentState = "wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction -> ... repeat
var actionQueue = []

func _ready() -> void:
	myAnimator.play("SceneAnimations");
	
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
		"enemyAction":
			currentState = "wingman1"
			myAnimator.play("SceneAnimations");
			myPlayerCharacter.tweenTo(Vector2(10,10),1);
			
	
	myTextLabel.text = String(currentState) + "\n" + String(actionQueue);
	

func _on_Button_pressed() -> void:
	next_phase()
	pass # Replace with function body.
