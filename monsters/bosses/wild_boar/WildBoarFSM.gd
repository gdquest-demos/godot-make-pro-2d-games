extends KinematicBody2D

signal target_position_changed
signal state_changed(new_state_name)
signal phase_changed(new_phase_name)

export(float) var MASS = 8.0
onready var start_global_position = global_position

var target_position = Vector2()

var state_active = null
var sequence_cycles = 0

enum PHASES {PHASE_ONE, PHASE_TWO, PHASE_THREE}
export(PHASES) var _phase = PHASE_ONE

func _ready():
	_change_phase(_phase)
	$AnimationPlayer.play("SETUP")

	if get_parent().has_node('Player'):
		var player_node = get_parent().get_node('Player')
		player_node.connect('position_changed', self, '_on_target_position_changed')
		target_position = player_node.global_position

	for state_node in $States.get_children():
		state_node.connect('finished', self, '_on_active_state_finished')
	go_to_next_state()

func _physics_process(delta):
	state_active.update(delta)

func _on_animation_finished(anim_name):
	state_active._on_animation_finished(anim_name)

func _on_active_state_finished():
	go_to_next_state()

func _on_Health_health_depleted():
	set_invincible(true)
	go_to_next_state($States/Die)

func go_to_next_state(state_override=null):
	if state_active:
		state_active.exit()
	state_active = state_override if state_override else _decide_on_next_state()
	emit_signal("state_changed", state_active.name)
	state_active.enter()

func _on_Health_health_changed(new_health):
	$Tween.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()

	if _phase == PHASE_ONE and new_health < 100:
		_change_phase(PHASE_TWO)
	if _phase == PHASE_TWO and new_health < 50:
		_change_phase(PHASE_THREE)

func _change_phase(new_phase):
	var phase_name = ""
	match new_phase:
		PHASE_ONE:
			$AnimationPlayer.playback_speed = 1.0
			phase_name = "One"
		PHASE_TWO:
			$AnimationPlayer.playback_speed = 1.4
			phase_name = "Two"
		PHASE_THREE:
			$AnimationPlayer.playback_speed = 1.8
			phase_name = "Three"

	emit_signal("phase_changed", phase_name)
	_phase = new_phase

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

	# PHASE ONE
	if _phase == PHASE_ONE:
		if state_active == $States/RoamSequence:
			sequence_cycles += 1
			if sequence_cycles < 2:
				return $States/RoamSequence
			else:
				sequence_cycles = 0
				return $States/Stomp
		if state_active == $States/Stomp:
			return $States/RoamSequence

	# PHASE TWO
	elif _phase == PHASE_TWO:
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


	# PHASE THREE
	elif _phase == PHASE_THREE:
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

func set_particles_active(value):
	$DustPuffsLarge.emitting = value

func set_invincible(value):
	$CollisionPolygon2D.disabled = value
	$HitBox/CollisionShape2D.disabled = value
	$CharacterDamager/CollisionShape2D.disabled = value

func _on_target_position_changed(new_position):
	target_position = new_position

func take_damage_from(attacker):
	$Health.take_damage_from(attacker)
