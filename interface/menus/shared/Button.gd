extends Button

func _gui_input(event):
	if event.is_action_pressed('ui_accept'):
		accept_event()
