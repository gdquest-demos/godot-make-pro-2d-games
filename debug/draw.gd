tool
extends Node2D

var DEBUG_MODE = null

var PINK = Color(ProjectSettings.get_setting('Colors/pink'))
var BLUE = Color(ProjectSettings.get_setting('Colors/blue'))
var PURPLE = Color(ProjectSettings.get_setting('Colors/purple'))
var YELLOW = Color(ProjectSettings.get_setting('Colors/yellow'))

const POINTS_COUNT = 24

var roam_radius = 0.0
var spawn_position = Vector2()
var spot_distance = 0.0
var follow_distance = 0.0

func _ready():
	var debug_node = get_tree().get_root().get_node('Game/Debug')
	if debug_node:
		debug_node.connect('debug_toggled', self, '_on_debug_toggled')
	DEBUG_MODE = ProjectSettings.get_setting('Debug/debug_mode')

func setup(_spawn_position, _roam_radius, _spot_distance, _follow_distance):
	roam_radius = _roam_radius
	spawn_position = _spawn_position
	spot_distance = _spot_distance
	follow_distance = _follow_distance
	update()

func draw_circle_outline(radius, color, offset=Vector2(), line_width=1.0):
	var points_array = PoolVector2Array()
	for i in range(POINTS_COUNT + 1):
		var angle = 2 * PI * i / POINTS_COUNT
		var point = offset + Vector2(cos(angle) * radius, sin(angle) * radius)
		points_array.append(point)
	draw_polyline(points_array, color, line_width, true)

func _on_debug_toggled(value):
	DEBUG_MODE = value
	visible = value
