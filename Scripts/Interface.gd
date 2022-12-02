extends Control


signal health_changed(hp)
signal enemy_HP_Updated(health)
signal game_over(win)
signal enemy_lost(lost)
func _on_Player_health_changed(hp):
	emit_signal("health_changed", hp)


func _on_Enemy_enemy_HP_Updated(health):
	emit_signal("enemy_HP_Updated", health)


func _on_Player_game_over(win):
	$Button.show()
	$Restart.show()
	$Panel.show()
	emit_signal("game_over", win)
	$Lost.show()
	pass # Replace with function body.


func _on_Enemy_enemy_lost(lost):
	if(lost == true):
		$Panel.show()
		$Button.show()
		$Restart.show()
		$Win.show()
		emit_signal("enemy_lost", lost)
	pass # Replace with function body.
