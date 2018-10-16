extends "res://utils/state/State.gd"

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var SLOW_RADIUS = 200.0
export(float) var MASS = 4.0
export(float) var MAX_SPEED = 300.0
export(float) var ROAM_RADIUS = 150.0

var target_position = Vector2()
var start_position = Vector2()
var velocity = Vector2()

func enter():
	start_position = get_parent().start_position
	target_position = calculate_new_target_position()
	owner.get_node('AnimationPlayer').play('move')

func update(delta):
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, MASS, SLOW_RADIUS, MAX_SPEED)
	owner.move_and_slide(velocity)
	if owner.get_slide_count() > 0:
		emit_signal('finished')
	elif owner.global_position.distance_to(target_position) < ARRIVE_DISTANCE:
		emit_signal('finished')

func calculate_new_target_position():
	randomize()
	var random_angle = randf() * 2 * PI
	randomize()
	var random_radius = (randf() * ROAM_RADIUS) / 2 + ROAM_RADIUS / 2
	return start_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
