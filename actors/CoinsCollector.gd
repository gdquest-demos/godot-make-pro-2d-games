extends Area2D

signal coins_received(amount)

const Coins = preload("res://core/inventory/items/Coins.gd")

func _on_area_entered(area):
	print(area)
	if not area is Coins:
		return
	area.queue_free()
	emit_signal("coins_received", area.amount)
