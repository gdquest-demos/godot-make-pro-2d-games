extends "res://interface/menus/Menu.gd"

onready var items_list = $Column/ItemsMenu

func initialize(args=[]):
	var inventory = args[0]
	items_list.initialize(inventory)
	
func open(inventory):
	.open()

func close():
	.close()
	queue_free()
