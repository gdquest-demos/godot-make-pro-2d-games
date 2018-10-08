extends KinematicBody2D

export(float) var MASS = 8.0
onready var start_global_position = global_position

var target

func _ready():
	_change_phase(_phase)
	$AnimationPlayer.play("SETUP")

	if get_parent().has_node('Player'):
		var player_node = get_parent().get_node('Player')
		player_node.connect('position_changed', self, '_on_target_position_changed')
		target_position = player_node.global_position

	for state_node in $States.get_children():
		state_node.connect('finished', self, '_on_active_state_finished')
	go_to_next_state()

func _on_Health_health_depleted():
	set_invincible(true)
	go_to_next_state($States/Die)

func _on_Health_health_changed(new_health):
	$Tween.interpolate_property($Pivot, 'scale', Vector2(0.92, 1.12), Vector2(1.0, 1.0), 0.3, Tween.TRANS_ELASTIC, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Pivot/Body, 'modulate', Color('#ff48de'), Color('#ffffff'), 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
	$Tween.start()

	if _phase == PHASE_ONE and new_health < 100:
		_change_phase(PHASE_TWO)
	if _phase == PHASE_TWO and new_health < 50:
		_change_phase(PHASE_THREE)

func set_particles_active(value):
	$DustPuffsLarge.emitting = value

func set_invincible(value):
	$CollisionPolygon2D.disabled = value
	$HitBox/CollisionShape2D.disabled = value
	$CharacterDamager/CollisionShape2D.disabled = value

func take_damage_from(attacker):
	$Health.take_damage(attacker.damage)
