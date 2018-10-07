extends Node

signal content_changed(items_as_string)
signal item_added(item)
signal item_removed(item)

func get_items():
	return get_children()

func find_item(reference):
	for item in get_items():
		if item.name == reference.name:
			return item

func has(item):
	return true if find_item(item) else false

func get_count(reference):
	var item = find_item(reference)
	return item.amount if item else 0

func add(reference, amount=1):
	var item = find_item(reference)
	if not item:
		item = _instance_item_from_db(reference)
		amount -= item.amount
	item.amount += amount
	emit_signal("content_changed", get_content_as_string())

func trash(reference, amount=1):
	var item = find_item(reference)
	if not item:
		return
	item.amount -= amount
	emit_signal("content_changed", get_content_as_string())

func use(item, user):
	item.use(user)
	emit_signal("content_changed", get_content_as_string())

func get_content_as_string():
	var string = ""
	for item in get_items():
		if item.amount == 0:
			continue
		string += "%s: %s" % [item.name, item.amount]
		string += "\n"
	return string

func _instance_item_from_db(reference):
	var item = ItemDatabase.get_item(reference)
	add_child(item)
	item.connect("depleted", self, "_on_Item_depleted", [item])
	emit_signal("item_added", item)
	return item

func _on_Item_depleted(item):
	emit_signal("item_removed", item)
