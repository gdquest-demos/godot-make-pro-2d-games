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
		'die': $Die,
	}
	for state in get_children():
		state.connect('finished', self, '_change_state')

func _change_state(state_name):
	if current_state == states_map['die']:
		set_active(false)
		return
	# Reset the player's jump height if transitioning away from jump to a state
	# that would stop jump's update method
	if current_state == states_map['jump'] and state_name in ['fall']:
		current_state.height = 0
	if not active:
		return
	if state_name in ['stagger', 'jump', 'attack']:
		states_stack.push_front(states_map[state_name])
	if state_name == 'jump' and current_state == $Move:
		$Jump.initialize($Move.speed, $Move.velocity)
	._change_state(state_name)

func _unhandled_input(event):
	if event.is_action_pressed('attack'):
		if current_state in [$Attack, $Stagger]:
			return
		_change_state('attack')
		get_tree().set_input_as_handled()
		return
	current_state.handle_input(event)

func _on_Health_damage_taken(new_health):
	_change_state('stagger')

func _on_Health_health_depleted():
	_change_state('die')
