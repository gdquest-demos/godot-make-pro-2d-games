tool
extends Panel

func _ready():
	set_as_toplevel(true)

func _on_WildBoar_state_changed(new_state_name):
	$State.text = new_state_name

func _on_WildBoar_phase_changed(new_phase_name):
	$Phase.text = "Phase: " + new_phase_name
