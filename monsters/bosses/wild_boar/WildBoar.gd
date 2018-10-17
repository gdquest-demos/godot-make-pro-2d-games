extends "res://monsters/Monster.gd"

signal hit_wall()

onready var state_machine = $StateMachine
onready var lifebar = $BossLifebar
onready var health_node = $Stats
onready var tween_node = $Tween

var start_global_position

func _ready():
	visible = false
	set_invincible(true)
	start_global_position = global_position
	lifebar.initialize(health_node)

func start():
	lifebar.appear()
	state_machine.start()

func _on_Health_health_depleted():
	set_invincible(true)
	lifebar.disappear()

func _on_Health_health_changed(new_health):
	tween_node.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	tween_node.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	tween_node.start()
	match state_machine.phase:
		1:
			if new_health < 100:
				state_machine.phase = 2
		2:
			if new_health < 50:
				state_machine.phase = 3

func set_particles_active(value):
	$DustPuffsLarge.emitting = value

func set_invincible(value):
	$CollisionPolygon2D.disabled = value
	$HitBox/CollisionShape2D.disabled = value
	$DamageSource/CollisionShape2D.disabled = value
	$DamageSource.monitorable = not value

func take_damage_from(attacker):
	health_node.take_damage(attacker.damage)

func _on_Die_finished():
	state_machine.set_active(false)
	emit_signal('died')
	queue_free()

func _on_target_died():
	._on_target_died()
	state_machine.change_phase(4)
	state_machine.go_to_next_state()

func _on_Sprint_hit_wall():
	emit_signal('hit_wall')
