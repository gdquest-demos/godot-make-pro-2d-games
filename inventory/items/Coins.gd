tool
extends Area2D

const CoinsCollector = preload("res://actors/CoinsCollector.gd")

export(int) var amount = 1 setget set_amount

func set_amount(value):
	amount = value
	# TODO: update the texture based on the amount

func _on_area_entered(area):
	if not area is CoinsCollector:
		return
	queue_free()
