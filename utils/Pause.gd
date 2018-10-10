extends "res://interface/menus/Menu.gd"

signal unpause()

const OptionsMenu = preload("res://interface/menus/pause/OptionsMenu.tscn")

func _ready():
	for node in $Background/Column.get_children():
		if not node is Button:
			continue
		if node.name == 'OptionsButton':
			node.connect('pressed', self, 'open_sub_menu', [OptionsMenu])
		else:
			node.connect('pressed', self, 'emit_signal', ['unpause'])

func open():
	.open()
	$Background/Column/ContinueButton.grab_focus()
