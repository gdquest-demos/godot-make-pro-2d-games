extends Control

onready var _money_label = $MoneyPanel/Count
onready var _owned_label = $OwnedPanel/Count

func initialize(purse):
	purse.connect("coins_changed", self, "_on_Purse_coins_changed")
	update_coins(purse.coins)

func update_coins(amount):
	_money_label.text = str(amount)

func update_amount(amount):
	_owned_label.text = str(amount)

func _on_Purse_coins_changed(coins):
	update_coins(coins)

func _on_focused_Item_amount_changed(item):
	update_amount(item.amount)

func _on_ItemsList_focused_button_changed(button):
	update_amount(button.amount)

func _on_ItemsList_item_amount_changed(amount):
	update_amount(amount)
