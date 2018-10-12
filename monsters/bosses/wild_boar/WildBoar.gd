extends "res://monsters/Monster.gd"

onready var state_machine = $StateMachine
onready var lifebar = $BossLifebar

var start_global_position

func _ready():
	visible = false
	set_invincible(true)
	start_global_position = global_position
	lifebar.initialize($Stats)

func start():
	lifebar.appear()
	state_machine.start()

func _on_Spawn_finished():
	set_invincible(false)

func _on_Health_health_depleted():
	set_invincible(true)
	lifebar.disappear()

func _on_Health_health_changed(new_health):
	$Tween.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()
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

func take_damage_from(attacker):
	$Stats.take_damage(attacker.damage)

func _on_Die_finished():
	state_machine.set_active(false)
	emit_signal('died')
	queue_free()
