# Base steering functions for monsters to use for movement
extends KinematicBody2D

signal died

var state = null

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var DEFAULT_SLOW_RADIUS = 200.0
export(float) var DEFAULT_MAX_SPEED = 300.0
export(float) var MASS = 8.0

var velocity = Vector2()
var has_target = false
var target_position = Vector2()

var start_position = Vector2()

func _ready():
	set_as_toplevel(true)
	start_position = global_position

func initialize(target):
	target_position = target.global_position
	target.connect('position_changed', self, '_on_target_position_changed')
	target.connect('died', self, '_on_target_died')
	has_target = true

func follow(velocity, target_position, max_speed):
	var desired_velocity = (target_position - position).normalized() * max_speed

	var push = calculate_avoid_force(desired_velocity)
	var steering = (desired_velocity - velocity + push) / MASS


	return velocity + steering


func arrive_to(velocity, target_position, slow_radius=DEFAULT_SLOW_RADIUS, max_speed=DEFAULT_MAX_SPEED, avoid=false):
	var distance_to_target = position.distance_to(target_position)

	var desired_velocity = (target_position - position).normalized() * max_speed
	if distance_to_target < slow_radius:
		desired_velocity *= (distance_to_target / slow_radius) * .75 + .25

	var push = calculate_avoid_force(desired_velocity) if avoid else Vector2()
	var steering = (desired_velocity - velocity + push) / MASS

	return velocity + steering


func calculate_avoid_force(desired_velocity):
	$RayCast2D.cast_to = desired_velocity.normalized() * 200
	$RayCast2D.force_raycast_update()
	var push = Vector2()
	if $RayCast2D.is_colliding():
		var normal = $RayCast2D.get_collision_normal()
		var point = $RayCast2D.get_collision_point()
		push = normal.rotated(PI/2) * 300 * (1 - position.distance_to(point) / 200)
	return push


func _on_target_position_changed(new_position):
	target_position = new_position


func _on_target_died():
	target_position = Vector2()
	has_target = false
