extends Area2D

signal shop_open_requested(shop, user)

const Player = preload("res://actors/player/PlayerController.gd")

func _unhandled_input(event):
	if not event.is_action_pressed("ui_accept"):
		return
	for body in get_overlapping_bodies():
		if body is Player:
			emit_signal("shop_open_requested", $Shop, body)
			get_tree().set_input_as_handled()
