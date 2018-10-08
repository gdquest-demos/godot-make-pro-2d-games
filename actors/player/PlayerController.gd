extends "res://actors/Actor.gd"

onready var weapon = $WeaponPivot/Offset/Sword
onready var camera = $ShakingCamera

func reset(target_global_position):
	.reset(target_global_position)
	camera.offset = Vector2()
