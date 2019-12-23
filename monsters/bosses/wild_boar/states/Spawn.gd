extends "res://utils/state/State.gd"

func enter():
	owner.set_invincible(true)
	owner.get_node('AnimationPlayer').play('spawn')

func exit():
	owner.set_invincible(false)

func _on_animation_finished(anim_name):
	assert(anim_name == 'spawn')
	emit_signal('finished')
