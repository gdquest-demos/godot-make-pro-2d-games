extends "res://utils/state/State.gd"

func enter():
	owner.get_node('AnimationPlayer').play('idle')
	$Timer.start()

func update(delta):
	if $Timer.time_left <= 0.0:
		emit_signal('finished')

func exit():
	$Timer.stop()
