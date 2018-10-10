extends "res://utils/state/StateMachine.gd"

func _ready():
	states_map = {
		'idle': $Idle,
		'move': $Move,
		'jump': $Jump,
		'bump': $Bump,
		'fall': $Fall,
		'stagger': $Stagger,
		'attack': $Attack,
	}
	for state in get_children():
		state.connect('finished', self, '_change_state')

func _change_state(state_name):
	if not _active:
		return
	if state_name in ['stagger', 'jump', 'attack']:
		states_stack.push_front(states_map[state_name])
	if state_name == 'jump' and current_state == $Move:
		$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state_name)

func _input(event):
	if event.is_action_pressed('attack'):
		if current_state in [$Attack, $Stagger]:
			return
		_change_state('attack')
		get_tree().set_input_as_handled()
		return
	current_state.handle_input(event)

func _on_Health_damage_taken(new_health):
	_change_state('stagger')
