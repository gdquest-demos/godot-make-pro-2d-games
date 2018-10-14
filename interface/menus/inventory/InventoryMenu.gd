extends "res://interface/menus/Menu.gd"

onready var items_list = $Column/ItemsMenu

func open(inventory):
	.open()
	items_list.initialize(inventory)

func close():
	.close()
	queue_free()
