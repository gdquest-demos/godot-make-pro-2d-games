extends Node

onready var level_loader = $LevelLoader
onready var transition = $Overlays/TransitionColor
onready var pause_menu = $Interface/PauseMenu
onready var tree = get_tree()

func _ready():
	$Interface.initialize($LevelLoader/Player)
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

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		pause()
		tree.set_input_as_handled()
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = not OS.window_fullscreen

func pause():
	tree.paused = true
	pause_menu.open()
	yield(pause_menu, "closed")
	tree.paused = false

func _on_ShopMenu_open():
	tree.paused = true

func _on_ShopMenu_closed():
	tree.paused = false
