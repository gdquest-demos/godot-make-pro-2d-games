extends "unpause_button.gd"

func _on_PauseMenu_pause_toggled(status):
	if status == true:
		grab_focus()
