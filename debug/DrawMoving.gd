tool
extends 'draw.gd'

func _draw():
	if not (DEBUG_MODE or Engine.editor_hint):
		return
	draw_circle_outline(spot_distance, YELLOW)
	draw_circle_outline(follow_distance, PINK)
