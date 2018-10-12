extends KinematicBody2D

signal died

var state
var active

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var DEFAULT_SLOW_RADIUS = 200.0
export(float) var DEFAULT_MAX_SPEED = 300.0
export(float) var MASS = 8.0

onready var stats = $Stats

const Actor = preload("res://actors/Actor.gd")
var target = null # Actor

var start_position = Vector2()
var velocity = Vector2()

func _ready():
	set_as_toplevel(true)
	start_position = global_position

func initialize(target_actor):
	if not target_actor is Actor:
		return
	target = target_actor
	target.connect('died', self, '_on_target_died')
	set_active(true)

func _on_target_died():
	target = null

func take_damage_from(damage_source):
	stats.take_damage(damage_source.damage)

func set_active(value):
	active = value
	set_physics_process(value)
	$HitBox.set_active(value)
	$DamageSource.set_active(value)
