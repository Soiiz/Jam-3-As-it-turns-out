extends Node2D

export var interest = 0

func _on_SampleScene_enemy_rumor(interest_gain):
	interest += interest_gain
