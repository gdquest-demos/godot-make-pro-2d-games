extends Area2D

signal coins_received(amount)

const Coins = preload("res://inventory/items/Coins.gd")

#func _process(delta):
#	for area in get_overlapping_areas():
#		if not area is Coins:
#			continue
#		area.steer_towards(global_position)

func _on_Collector_area_entered(area):
	if not area is Coins:
		return
	print(area)
	emit_signal("coins_received", area.amount)
