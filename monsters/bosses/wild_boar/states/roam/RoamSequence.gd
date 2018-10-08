extends "res://utils/state/Sequence.gd"

var start_position = Vector2()

func enter():
	start_position = owner.global_position
	.enter()

func exit():
	.exit()

func update(delta):
	.update(delta)
