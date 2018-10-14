extends "res://interface/menus/Menu.gd"

signal unpause()

const OptionsMenu = preload("res://interface/menus/pause/OptionsMenu.tscn")

onready var continue_button = $Background/Column/ContinueButton
onready var items_button = $Background/Column/ItemsButton
onready var options_button = $Background/Column/OptionsButton

onready var inventory_menu = $InventoryMenu

func _ready():
	options_button.connect('pressed', self, 'open_sub_menu', [OptionsMenu])

func initialize(inventory):
	inventory_menu.initialize(inventory)
	items_button.connect('pressed', inventory_menu, 'open', [inventory])

func open():
	.open()
	continue_button.grab_focus()
