extends Control

signal pause_toggled(status)

func _input(event):
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		set_paused(new_pause_state)

func set_paused(value):
	get_tree().paused = value
	visible = value
	emit_signal("pause_toggled", value)

