extends Control


signal health_changed(hp)


func _on_Player_health_changed(hp):
	emit_signal("health_changed", hp)
