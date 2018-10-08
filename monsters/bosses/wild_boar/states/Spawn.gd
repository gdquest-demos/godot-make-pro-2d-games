extends "res://utils/state/State.gd"

func enter():
	owner.get_node('AnimationPlayer').play('spawn')

func _on_animation_finished(anim_name):
	assert anim_name == 'spawn'
	emit_signal('finished')
