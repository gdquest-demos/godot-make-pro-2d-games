extends Node

export(bool) var STOCK_INFINITE = false
export(bool) var MONEY_INFINITE = false

export(int) var MAX_TRANSACTION_COUNT = 100
export(float, 0.0, 1.0) var BUY_MULTIPLIER = 0.25

onready var inventory = $Inventory
onready var purse = $Purse

func buy_from(actor, item, amount=1):
	amount = clamp(amount, 1, MAX_TRANSACTION_COUNT)
	var transaction_value = max(get_buy_value(item) * amount, purse.coins)

	actor.get_node("Inventory").trash(item, amount)
	actor.get_node("Purse").add_coins(transaction_value)
	
	if not STOCK_INFINITE:
		inventory.add(item, amount)
	if not MONEY_INFINITE:
		purse.remove_coins(transaction_value)

func sell_to(actor, item, amount=1):
	amount = clamp(amount, 1, MAX_TRANSACTION_COUNT)
	var transaction_value = item.price * amount
#	The UI should show/handle that by disabling buttons
#	var actor_purse = actor.get_node("Purse")
#	if not actor_purse.has_coins(transaction_value):
#		return
	actor.get_node("Purse").remove_coins(item.price * amount)
	actor.get_node("Inventory").add(item, amount)

	if not STOCK_INFINITE:
		inventory.trash(item, amount)
	if MONEY_INFINITE:
		return
	purse.add_coins(item.price * amount)

func get_buy_value(item):
	return round(item.price * BUY_MULTIPLIER)
