extends Particles2D

func start():
	emitting = true
	yield(get_tree().create_timer(lifetime * speed_scale * 1.2), "timeout")
	queue_free()
