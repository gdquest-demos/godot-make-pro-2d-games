extends Position2D

func _on_Player_direction_changed(new_direction):
	rotation = new_direction.angle()
	show_behind_parent = new_direction == Vector2(0, -1)
