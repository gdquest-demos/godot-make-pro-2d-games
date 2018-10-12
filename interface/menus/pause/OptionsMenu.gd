extends "res://interface/menus/Menu.gd"

func _ready():
	open()

func open():
	.open()
	$Column/GoBackButton.grab_focus()

func close():
	queue_free()
	.close()
