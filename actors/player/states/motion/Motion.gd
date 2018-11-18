# Collection of important methods to handle direction and animation
extends "res://utils/state/State.gd"

func handle_input(event):
	if event.is_action_pressed("discrete_move_left") or Input.is_action_pressed("joy_move_left") \
	or event.is_action_pressed("discrete_move_right") or Input.is_action_pressed("joy_move_right") \
	or event.is_action_pressed("discrete_move_up") or Input.is_action_pressed("joy_move_up") \
	or event.is_action_pressed("discrete_move_down") or Input.is_action_pressed("joy_move_down"):
		get_tree().set_input_as_handled()

func get_input_direction():
	var input_direction = Vector2()
	
	input_direction.x = \
		int(Input.is_action_pressed("discrete_move_right") or Input.is_action_pressed("joy_move_right")) - \
		int(Input.is_action_pressed("discrete_move_left") or Input.is_action_pressed("joy_move_left"))
	input_direction.y = \
		int(Input.is_action_pressed("discrete_move_down") or Input.is_action_pressed("joy_move_down")) - \
		int(Input.is_action_pressed("discrete_move_up") or Input.is_action_pressed("joy_move_up"))
	
	return input_direction

func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
