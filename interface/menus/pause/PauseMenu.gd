extends Menu

signal unpause()

const InventoryMenu = preload("res://interface/menus/inventory/InventoryMenu.tscn")
const PlayerController = preload("res://actors/player/PlayerController.gd")

onready var continue_button = $Background/Column/ContinueButton
onready var items_button = $Background/Column/ItemsButton
onready var options_button = $Background/Column/OptionsButton
onready var save_button = $Background/Column/SaveButton

onready var buttons_container = $Background/Column

onready var save_menu = $SaveMenu
onready var options_menu = $OptionsMenu

func _ready():
	options_button.connect('pressed', self, 'open_sub_menu', [options_menu])
	save_button.connect('pressed', self, 'open_sub_menu', [save_menu])
	remove_child(save_menu)
	remove_child(options_menu)

"""args: {actor}"""
func initialize(args={}):
	var actor = args['actor']
	assert(actor is PlayerController)
	var inventory = actor.get_inventory()
	items_button.connect('pressed', self, 'open_sub_menu', [InventoryMenu, {'inventory':inventory}])
	actor.connect('died', self, '_on_Player_died')

func _on_Player_died():
	items_button.disabled = true

func open(args={}):
	.open()
	continue_button.grab_focus()

func open_sub_menu(menu, args={}):
	var last_focused_item = get_focus_owner()
	buttons_container.hide()
	yield(.open_sub_menu(menu, args), 'completed')
	buttons_container.show()
	last_focused_item.grab_focus()
