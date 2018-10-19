extends "res://utils/state/StateMachine.gd"

signal phase_changed(number)

var sequence_cycles = 0
export(int, 1, 3) var phase = 1

func _ready():
	for child in get_children():
		child.connect("finished", self, "go_to_next_state")

func initialize():
	change_phase(phase)

func _on_active_state_finished():
	go_to_next_state()

func go_to_next_state(state_override=null):
	if not active:
		return
	current_state.exit()
	current_state = _decide_on_next_state() if state_override == null else state_override
	emit_signal("state_changed", current_state)
	current_state.enter()

func _decide_on_next_state():
	# Battle start
	if current_state == null:
		return $Spawn
	if current_state == $Spawn:
		return $RoamSequence

	if phase == 1:
		if current_state == $RoamSequence:
			sequence_cycles += 1
			if sequence_cycles < 2:
				return $RoamSequence
			else:
				sequence_cycles = 0
				return $Stomp
		if current_state == $Stomp:
			return $RoamSequence

	elif phase == 2:
		if current_state == $RoamSequence:
			return $Stomp
		if current_state == $Stomp:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $Stomp
			else:
				sequence_cycles = 0
				return $ChargeSequence
		if current_state == $ChargeSequence:
			return $RoamSequence

	elif phase == 3:
		if current_state == $RoamSequence:
			return $Stomp
		if current_state == $Stomp:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $Stomp
			else:
				sequence_cycles = 0
				return $ChargeSequence
		if current_state == $ChargeSequence:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $ChargeSequence
			else:
				sequence_cycles = 0
				return $Stomp
	elif phase == 4:
		return $RoamSequence

func change_phase(new_phase):
	phase = new_phase
	var anim_player = owner.get_node('AnimationPlayer')
	match new_phase:
		1:
			anim_player.playback_speed = 1.0
		2:
			anim_player.playback_speed = 1.4
		3:
			anim_player.playback_speed = 1.8
		4:
			anim_player.playback_speed = 1.0
	emit_signal("phase_changed", new_phase)

func _on_Health_health_depleted():
	go_to_next_state($Die)
