extends Node

onready var level = $Level
onready var transition = $Overlays/TransitionColor

func _ready():
	level.initialize()
	for door in level.get_doors():
		door.connect("player_entered", self, "_on_Door_player_entered")

func change_level(scene_path):
	get_tree().paused = true
	yield(transition.fade_to_color(), "completed")
	
	level.change_level(scene_path)
	for door in level.get_doors():
		door.connect("player_entered", self, "_on_Door_player_entered")

	yield(transition.fade_from_color(), "completed")
	get_tree().paused = false

func _on_Door_player_entered(target_map):
	change_level(target_map)
