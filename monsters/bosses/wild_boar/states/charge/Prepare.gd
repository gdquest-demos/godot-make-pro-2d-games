extends "res://utils/state/State.gd"

func enter():
	owner.get_node('AnimationPlayer').play('prepare')

func _on_animation_finished(anim_name):
	emit_signal('finished')
