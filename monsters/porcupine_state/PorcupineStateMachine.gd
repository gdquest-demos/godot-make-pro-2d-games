extends "res://utils/state/StateMachine.gd"

var states_map = {
	'roam': $RoamSequence,
	'charge': $ChargeSequence,
}

func _ready():
	for state_node in $States.get_children():
		state_node.connect('finished', self, '_on_active_state_finished')
	initialize(get_child(0))

func _on_active_state_finished(next_state=''):
	if next_state == '':
		next_state = _decide_next_state()
	_change_state(next_state)

func _decide_next_state():
	return 'roam'
