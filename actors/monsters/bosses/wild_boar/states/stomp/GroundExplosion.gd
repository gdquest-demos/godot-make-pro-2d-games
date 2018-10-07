extends "res://actors/damage_source.gd"

func _ready():
	$AnimationPlayer.play('explode')

func _physics_process(delta):
	position = position
