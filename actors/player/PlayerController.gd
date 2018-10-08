extends "res://actors/Actor.gd"

onready var weapon = $WeaponPivot/Offset/Sword
onready var camera = $ShakingCamera

func reset(target_global_position):
	.reset(target_global_position)
	camera.offset = Vector2()

func take_damage_from(damage_source):
	.take_damage_from(damage_source)
	$StateMachine/Stagger.knockback_direction = (damage_source.global_position - global_position).normalized()
