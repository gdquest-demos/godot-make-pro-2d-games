extends "res://utils/state/StateMachine.gd"

var sequence_cycles = 0
export(int, 1, 3) var _phase = 1 setget _set_phase

func _ready():
	_set_phase(_phase)
	$AnimationPlayer.play("SETUP")
	._ready()

func _on_active_state_finished():
	go_to_next_state()

func go_to_next_state(state_override=null):
	var new_state = state_override if state_override else _decide_on_next_state()
	_change_state(new_state)

func _decide_on_next_state():
	# Battle start
	if state_active == null:
		set_invincible(true)
		return $States/Spawn
	if state_active == $States/Spawn:
		set_invincible(false)
		return $States/RoamSequence
	# Death
	if state_active == $States/Die:
		queue_free()
		return $States/Dead

	if _phase == 1:
		if state_active == $States/RoamSequence:
			sequence_cycles += 1
			if sequence_cycles < 2:
				return $States/RoamSequence
			else:
				sequence_cycles = 0
				return $States/Stomp
		if state_active == $States/Stomp:
			return $States/RoamSequence

	elif _phase == 2:
		if state_active == $States/RoamSequence:
			return $States/Stomp
		if state_active == $States/Stomp:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $States/Stomp
			else:
				sequence_cycles = 0
				return $States/ChargeSequence
		if state_active == $States/ChargeSequence:
			return $States/RoamSequence


	elif _phase == 3:
		if state_active == $States/RoamSequence:
			return $States/Stomp
		if state_active == $States/Stomp:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $States/Stomp
			else:
				sequence_cycles = 0
				return $States/ChargeSequence
		if state_active == $States/ChargeSequence:
			if sequence_cycles < 2:
				sequence_cycles += 1
				return $States/ChargeSequence
			else:
				sequence_cycles = 0
				return $States/Stomp


func _on_Health_health_changed(new_health):
	$Tween.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
	match _phase:
		1:
			if new_health < 100:
				self._phase = 2
		2:
			if new_health < 50:
				self._phase = 3

func _set_phase(new_phase):
	var phase_name = ""
	match new_phase:
		1:
			$AnimationPlayer.playback_speed = 1.0
			phase_name = "One"
		2:
			$AnimationPlayer.playback_speed = 1.4
			phase_name = "Two"
		3:
			$AnimationPlayer.playback_speed = 1.8
			phase_name = "Three"

	emit_signal("phase_changed", phase_name)
	_phase = new_phase
