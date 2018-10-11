extends Area2D

signal coins_received(amount)

const Coins = preload("res://inventory/items/Coins.gd")

func _on_area_entered(area):
	if not area is Coins:
		return
	emit_signal("coins_received", area.amount)
