extends "res://utils/state/State.gd"

signal charge_direction_set(direction)
signal hit_wall()

export(float) var SPEED = 1000.0
export(float) var MAX_DISTANCE = 1200.0

var direction = Vector2()
var distance = 0.0

const DirectionalRock = preload("res://vfx/particles/rocks/DirectionalRock.tscn")
const PlayerController = preload("res://actors/player/PlayerController.gd")

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
		var collision = owner.get_slide_collision(0)
		if not collision.collider is PlayerController:
			spawn_rock_particles(collision)
			emit_signal('hit_wall')
		emit_signal('charge_direction_set', direction)
		emit_signal('finished')
	elif distance > MAX_DISTANCE:
		emit_signal('charge_direction_set', Vector2())

func spawn_rock_particles(collision):
	var rock_particles = DirectionalRock.instance()
	add_child(rock_particles)
	rock_particles.initialize(collision.position, collision.normal.angle())
