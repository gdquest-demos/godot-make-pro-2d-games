extends Area2D

const DamageSource = preload("res://actors/DamageSource.gd")

func _on_area_entered(area):
	if not area is DamageSource:
		return
	if not owner.has_node('Health'):
		return
	owner.take_damage_from(area)
