extends "res://actors/Actor.gd"

onready var weapon = $WeaponPivot/Offset/Sword
onready var camera = $ShakingCamera
onready var state_machine = $StateMachine

func reset(target_global_position):
	.reset(target_global_position)
	camera.offset = Vector2()
	camera.current = true

func take_damage_from(damage_source):
	.take_damage_from(damage_source)
	$StateMachine/Stagger.knockback_direction = (damage_source.global_position - global_position).normalized()
	camera.start_shake()

func move(speed, direction):
	var velocity = direction.normalized() * speed
	move_and_slide(velocity, Vector2(), 5, 2)
	emit_signal("position_changed", position)
	if get_slide_count() == 0:
		return
	return get_slide_collision(0)

func fall(gap_size):
	"""
	Interrupts the state machine and goes to the Fall state
	"""
	state_machine._change_state('fall')
	yield(state_machine.current_state, 'finished')
	move_and_collide(-look_direction * gap_size * 1.5)
