extends "res://utils/state/State.gd"

export(float) var SPEED = 240.0
var direction = Vector2(-1.0, 0.0)

func _on_Move_last_moved(moved_direction):
	direction = -moved_direction

func enter():
	owner.get_node('AnimationPlayer').play('bump')

func update(delta):
	owner.move_and_slide(direction * SPEED)

func _on_animation_finished(anim_name):
	emit_signal('finished', 'idle')
