extends "res://utils/state/State.gd"

func enter():
	owner.set_dead(true)
	owner.get_node("AnimationPlayer").play("die")
