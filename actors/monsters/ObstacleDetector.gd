# Detects collisions with the environment using raycasts
# If collisions happen, emits a signal with a list of collision points
extends Node2D

signal rays_collided

var rays = []
const RAYS_COUNT = 12
const RAYS_RADIUS = 100

func _ready():
	for i in range(RAYS_COUNT):
		var new_ray = RayCast2D.new()
		var angle = 2 * PI * i / RAYS_COUNT
		new_ray.cast_to = Vector2(cos(angle), sin(angle)) * RAYS_RADIUS
		add_child(new_ray)
		new_ray.add_exception(get_parent().get_parent())
		new_ray.enabled = true
		new_ray.collision_mask = 2


func _physics_process(delta):
	var collision_points = []
	for ray in get_children():
		if not ray.is_colliding():
			continue
		collision_points.append(ray.get_collision_point())
	if collision_points == []:
		return
	emit_signal('rays_collided', collision_points)
