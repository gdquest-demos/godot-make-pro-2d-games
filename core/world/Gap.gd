extends Area2D

func _on_body_entered(body):
	if not body.has_method('fall'):
		return
	body.fall($CollisionShape2D.shape.extents)
