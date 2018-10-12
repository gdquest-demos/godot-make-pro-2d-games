extends "res://interface/menus/Menu.gd"

signal unpause()

const OptionsMenu = preload("res://interface/menus/pause/OptionsMenu.tscn")

func _ready():
	$Background/Column/OptionsButton.connect('pressed', self, 'open_sub_menu', [OptionsMenu])

func open():
	.open()
	$Background/Column/ContinueButton.grab_focus()
