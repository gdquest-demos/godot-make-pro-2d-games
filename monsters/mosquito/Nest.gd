extends Node2D

export(int) var MAX_MOSQUITO_COUNT = 2

var mosquito_scene = preload("Mosquito.tscn")
onready var timer = $SpawnTimer
onready var collision_shape = $SpawnArea/CollisionShape2D

func spawn_mosquito():
	var new_mosquito = mosquito_scene.instance()
	new_mosquito.global_position = calculate_random_spawn_position()
	add_child(new_mosquito)

func calculate_random_spawn_position():
	var spawn_center = collision_shape.global_position
	var spawn_radius = collision_shape.shape.radius

	var random_angle = randf() * 2 * PI
	var random_radius = randf() * spawn_radius / 2 + spawn_radius / 2

	return spawn_center + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)

func _on_SpawnTimer_timeout():
	if get_child_count() < MAX_MOSQUITO_COUNT:
		spawn_mosquito()
