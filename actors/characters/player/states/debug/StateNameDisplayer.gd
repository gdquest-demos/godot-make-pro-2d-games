extends Label

func _on_StateMachine_state_changed(current_state):
	text = current_state.name
