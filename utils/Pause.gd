extends "res://interface/menus/Menu.gd"

signal unpause()

func _ready():
	for node in $Background/Column.get_children():
		if not node is Button:
			continue
		node.connect('pressed', self, 'emit_signal', ['unpause'])

func open():
	.open()
	$Background/Column/ContinueButton.grab_focus()
