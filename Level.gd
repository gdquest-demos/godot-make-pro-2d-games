extends Node

signal loaded()

export(String, FILE, "*.tscn") var LEVEL_START
export(PackedScene) var Player = preload("res://actors/player/Player.tscn")

var map
var player

func initialize():
	player = Player.instance()
	change_level(LEVEL_START)

func change_level(scene_path):
	if map:
		map.remove_child(player)
		map.queue_free()
	map = load(scene_path).instance()
	add_child(map)
	move_child(map, 0)

	map.add_child(player)
	var spawn = map.get_node("PlayerSpawningPoint")
	player.reset(spawn.global_position)
	
	for monster in get_tree().get_nodes_in_group("monster"):
		monster.initialize(player)
	if map.has_method('initialize'):
		map.initialize()
	emit_signal("loaded")

func get_doors():
	var doors = []
	for door in get_tree().get_nodes_in_group("doors"):
		if not map.is_a_parent_of(door):
			continue
		doors.append(door)
	return doors
