extends Control

signal item_use_requested(item, actor)

export(PackedScene) var ItemButton

onready var _item_grid = $Column/ItemsList/Margin/Grid
onready var _description_label = $Column/DescriptionPanel/Margin/Label

func initialize(inventory):
	var buttons = []
	for item in inventory.get_items():
		var item_button = create_item_button(item)
		item_button.connect("focus_entered", self, "_on_ItemButton_focus_entered")
		item_button.connect("pressed", self, "_on_ItemButton_pressed", [item])
		buttons.append(item_button)
	_item_grid.initialize(buttons)

	inventory.connect("item_added", self, "create_item_button")
	connect("item_use_requested", inventory, "use")

func create_item_button(item):
	var item_button = ItemButton.instance()
	item_button.initialize(item)
	return item_button

func _on_ItemButton_focus_entered():
	_description_label.text = get_focus_owner().description

func _on_ItemButton_pressed(item):
	var button = get_focus_owner()
	$UserSelectMenu.open()
	var actor = yield($UserSelectMenu, "closed")
	button.grab_focus()
	if not actor:
		return
	emit_signal("item_use_requested", item, actor)
