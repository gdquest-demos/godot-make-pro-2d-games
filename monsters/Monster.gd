# Base steering functions for monsters to use for movement
extends KinematicBody2D

signal died

var state = null

const Actor = preload("res://actors/Actor.gd")

export(float) var ARRIVE_DISTANCE = 6.0
export(float) var DEFAULT_SLOW_RADIUS = 200.0
export(float) var DEFAULT_MAX_SPEED = 300.0
export(float) var MASS = 8.0

var target = null # Actor

var start_position = Vector2()
var velocity = Vector2()

func _ready():
	set_as_toplevel(true)
	start_position = global_position

func initialize(actor):
	if not actor is Actor:
		return
	target = actor
	target.connect('died', self, '_on_target_died')

func _on_target_died():
	target = null
