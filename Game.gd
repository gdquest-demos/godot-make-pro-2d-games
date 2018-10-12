extends Node

signal pause_toggled(status)

onready var level_loader = $LevelLoader
onready var transition = $Overlays/TransitionColor
onready var pause_menu = $Interface/PauseMenu
onready var tree = get_tree()

func _ready():
	$Interface/PlayerGUI.initialize($LevelLoader/Player/Health)
	level_loader.initialize()
	for door in level_loader.get_doors():
		door.connect("player_entered", self, "_on_Door_player_entered")

func change_level(scene_path):
	tree.paused = true
	yield(transition.fade_to_color(), "completed")
	
	level_loader.change_level(scene_path)
	for door in level_loader.get_doors():
		door.connect("player_entered", self, "_on_Door_player_entered")

	yield(transition.fade_from_color(), "completed")
	tree.paused = false

func _on_Door_player_entered(target_map):
	change_level(target_map)

func _input(event):
	if event.is_action_pressed("pause"):
		set_paused(not tree.paused)
		tree.set_input_as_handled()

func set_paused(pause):
	tree.paused = pause
	if pause:
		pause_menu.open()
	else:
		pause_menu.close()
	emit_signal("pause_toggled", pause)

func _on_PauseMenu_unpause():
	set_paused(false)
