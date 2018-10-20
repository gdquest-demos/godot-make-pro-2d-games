extends "res://actors/Actor.gd"

onready var weapon = $BodyPivot/WeaponPivot/Offset/Sword
onready var camera = $ShakingCamera
onready var state_machine = $StateMachine
onready var anim_player = $AnimationPlayer
onready var body = $BodyPivot/Body
onready var purse = $Purse

func _ready():
	anim_player.play('SETUP')
	state_machine.start()

func reset(target_global_position):
	.reset(target_global_position)
	anim_player.play('SETUP')
	camera.offset = Vector2()
	camera.current = true

func get_body():
	return body

func take_damage_from(damage_source):
	if state_machine.current_state == $StateMachine/Stagger:
		return
	.take_damage_from(damage_source)
	$StateMachine/Stagger.knockback_direction = (damage_source.global_position - global_position).normalized()
	camera.shake = true

func move(velocity):
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
	$Health.take_damage(2)

func _on_Die_finished(string):
	set_dead(true)

func get_health_node():
	return $Health

func get_inventory():
	return $Inventory

func get_purse():
	return purse
