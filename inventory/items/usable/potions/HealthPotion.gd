extends "res://inventory/items/Item.gd"

export(int) var HEAL_AMOUNT = 20

func _apply_effect(user):
	if not user.has_node("Health"):
		return

	user.get_node("Health").heal(HEAL_AMOUNT)
	user.get_node("AnimationPlayer").play("heal")
