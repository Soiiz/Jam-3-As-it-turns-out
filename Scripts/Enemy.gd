extends Node2D

signal enemy_HP_Updated(health)

export var interest = 0
func ready():
	emit_signal("enemy_HP_Updated", interest)

func _on_SampleScene_enemy_rumor(interest_gain):
	interest += interest_gain
	emit_signal("enemy_HP_Updated", interest)
	print("interest: " + str(interest))
