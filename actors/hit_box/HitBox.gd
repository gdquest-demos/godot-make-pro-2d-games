extends Area2D

func _on_HitBox_area_entered(area):
	if not owner.has_node('Health'):
		return
	owner.take_damage_from(area)
