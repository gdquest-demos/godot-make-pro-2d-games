extends "res://utils/state/State.gd"

signal charge_direction_set(direction)

export(float) var SPEED = 1000.0
export(float) var MAX_DISTANCE = 1200.0

var direction = Vector2()
var distance = 0.0

func enter():
	distance = 0.0
	direction = (owner.target.global_position - owner.global_position).normalized()
	owner.get_node('AnimationPlayer').play('sprint')
	owner.set_particles_active(true)

func exit():
	owner.set_particles_active(false)

func update(delta):
	var velocity = SPEED * direction
	owner.move_and_slide(velocity)
	distance += velocity.length() * delta

	if owner.get_slide_count() > 0:
		emit_signal('charge_direction_set', direction)
		emit_signal('finished')
	elif distance > MAX_DISTANCE:
		emit_signal('charge_direction_set', Vector2())
