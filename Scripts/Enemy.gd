extends Node2D

var lost = false
signal enemy_HP_Updated(health)
signal enemy_lost(lost)
export var interest = 0
func ready():
	emit_signal("enemy_HP_Updated", interest)

func _on_SampleScene_enemy_rumor(interest_gain):
	interest += interest_gain
	emit_signal("enemy_HP_Updated", interest)
	if(interest >= 100):
		lost = true
		emit_signal("enemy_lost", lost)
	print("interest: " + str(interest))
