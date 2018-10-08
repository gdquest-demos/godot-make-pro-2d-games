extends Node2D

export(int) var MAX_MOSQUITO_COUNT = 2

var Mosquito = preload("Mosquito.tscn")

onready var timer = $SpawnTimer
onready var collider = $SpawnArea/CollisionShape2D
onready var mosquitos = $Mosquitos

var target

func initialize(actor):
	target = actor

func _on_SpawnTimer_timeout():
	if mosquitos.get_child_count() < MAX_MOSQUITO_COUNT:
		spawn_mosquito()

func spawn_mosquito():
	var new_mosquito = Mosquito.instance()
	new_mosquito.global_position = calculate_random_spawn_position()
	new_mosquito.initialize(target)
	mosquitos.add_child(new_mosquito)

func calculate_random_spawn_position():
	var spawn_radius = collider.shape.radius

	var random_angle = randf() * 2 * PI
	var random_radius = randf() * spawn_radius / 2 + spawn_radius / 2

	return collider.global_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
