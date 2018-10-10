extends "OnGround.gd"

signal last_moved(direction)

export(float) var MAX_WALK_SPEED = 450
export(float) var MAX_RUN_SPEED = 700

func enter():
	speed = 0.0

	var input_direction = get_input_direction()
	update_look_direction(input_direction)
	owner.get_node("AnimationPlayer").play("walk")

func exit():
	owner.get_node("AnimationPlayer").play("idle")

func handle_input(event):
	return .handle_input(event)

func update(delta):
	var input_direction = get_input_direction()
	if not input_direction:
		emit_signal("finished", "idle")
	update_look_direction(input_direction)

	speed = MAX_RUN_SPEED if Input.is_action_pressed("run") else MAX_WALK_SPEED
	var collision_info = owner.move(speed, input_direction)
	if not collision_info:
		return
	if speed == MAX_RUN_SPEED and collision_info.collider.is_in_group("environment"):
		emit_signal("last_moved", input_direction)
		emit_signal("finished", 'bump')
