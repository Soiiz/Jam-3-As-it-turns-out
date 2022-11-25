extends Node

onready var SceneConnection = get_parent();

func _on_W1O1_pressed() -> void:
	if !SceneConnection.currentState == "wingman1":
		return; #"wingman1" #wingman1 -> wingman2 -> player -> exeuctingQueue -> enemyAction
	SceneConnection.add_action("VibeCheck")
	SceneConnection.next_phase()

func _on_W1O2_pressed() -> void:
	if !SceneConnection.currentState == "wingman1":
		return;
	SceneConnection.add_action("Rizz")
	SceneConnection.next_phase()
	pass # Replace with function body.

func _on_W1O3_pressed() -> void:
	if !SceneConnection.currentState == "wingman1":
		return;
	SceneConnection.add_action("Soda")
	SceneConnection.next_phase()
	pass # Replace with function body.


func _on_W2O1_pressed() -> void:
	if !SceneConnection.currentState == "wingman2":
		return;
	SceneConnection.add_action("GoodRumor")
	SceneConnection.next_phase()
	pass # Replace with function body.


func _on_W202_pressed() -> void:
	if !SceneConnection.currentState == "wingman2":
		return;
	SceneConnection.add_action("Console")
	SceneConnection.next_phase()
	pass # Replace with function body.


func _on_W203_pressed() -> void:
	if !SceneConnection.currentState == "wingman2":
		return;
	SceneConnection.add_action("Protect")
	SceneConnection.next_phase()
	pass # Replace with function body.


func _on_Player1_pressed() -> void:
	if !SceneConnection.currentState == "player":
		return;
	SceneConnection.add_action("Compliment")
	SceneConnection.next_phase()
	pass # Replace with function body.
	pass # Replace with function body.


func _on_Player2_pressed() -> void:
	if !SceneConnection.currentState == "player":
		return;
	SceneConnection.add_action("Flirt")
	SceneConnection.next_phase()
	pass # Replace with function body.


func _on_Player3_pressed() -> void:
	if !SceneConnection.currentState == "player":
		return;
	SceneConnection.add_action("Gift")
	SceneConnection.next_phase()

	pass # Replace with function body.
