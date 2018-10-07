tool
extends 'draw.gd'

func _ready():
	set_as_toplevel(true)

func _draw():
	if not (DEBUG_MODE or Engine.editor_hint):
		return
	draw_circle_outline(roam_radius, BLUE, spawn_position)
