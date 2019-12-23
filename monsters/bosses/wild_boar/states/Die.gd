extends "res://utils/state/State.gd"

export(float) var MAX_RADIUS = 300.0
export(PackedScene) var Explosion

func enter():
	owner.get_node('AnimationPlayer').play('die')
	$ExplodeTimer.start()

func _on_ExplodeTimer_timeout():
	spawn_explosion()

func spawn_explosion():
	var explosion_node = Explosion.instance()
	explosion_node.position = owner.position + calculate_random_offset()
	add_child(explosion_node)

func calculate_random_offset():
	randomize()
	var random_angle = randf() * 2 * PI
	randomize()
	var random_radius = (randf() * MAX_RADIUS) / 2 + MAX_RADIUS / 2
	return Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)

func _on_animation_finished(anim_name):
	$ExplodeTimer.stop()
	assert(anim_name == 'die')
	get_tree().create_timer(0.6).connect("timeout", self, 'emit_signal', ['finished'])
