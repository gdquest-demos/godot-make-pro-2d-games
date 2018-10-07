extends Button

signal amount_changed(value)

var description = ""
var amount = 0

func initialize(item, price):
	$Name.text = item.display_name
	$Price.text = str(price)
	$Icon.texture = item.icon
	
	description = item.description
	amount = item.amount
	
	item.connect("amount_changed", self, "_on_Item_amount_changed")
	item.connect("depleted", self, "_on_Item_depleted")

func _on_Item_depleted():
	disabled = true

func _on_Item_amount_changed(value):
	amount = value
	emit_signal("amount_changed", value)
