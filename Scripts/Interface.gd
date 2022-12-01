extends Control


signal health_changed(hp)
signal enemy_HP_Updated(health)

func _on_Player_health_changed(hp):
	emit_signal("health_changed", hp)


func _on_Enemy_enemy_HP_Updated(health):
	emit_signal("enemy_HP_Updated", health)
