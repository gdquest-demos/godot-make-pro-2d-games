tool
extends "res://actors/camera/ShakingCamera.gd"

onready var tween = $Tween

export(float) var AMPLITUDE_HIT_WALL = 30.0

var start_global_position = Vector2()
onready var _start_amplitude = amplitude

func _ready():
	start_global_position = global_position

func initialize(player):
	global_position = player.camera.global_position
	player.get_health_node().connect('damage_taken', self, '_on_Player_damage_taken')
	current = true

func move_to_room_center():
	tween.interpolate_property(self, 'global_position', global_position, start_global_position, 1.0, Tween.TRANS_QUART, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")

func _on_WildBoar_hit_wall():
	amplitude = AMPLITUDE_HIT_WALL
	self.shake = true

func _on_Player_damage_taken(new_health):
	amplitude = _start_amplitude
	self.shake = true
