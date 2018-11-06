# Collection of important methods to handle direction and animation
extends "res://utils/state/State.gd"

var joypad_dead_zone = ProjectSettings.get_setting("arpg/input/joypad_deadzone")

enum PreferredInputSource { KEYBOARD, JOYPAD }
var preferred_input_source = PreferredInputSource.KEYBOARD

func handle_input(event):
	if event is InputEventKey and preferred_input_source != PreferredInputSource.KEYBOARD:
		preferred_input_source = PreferredInputSource.KEYBOARD
		print("Key pressed. Changing preferred input method to keyboard...")
	elif event is InputEventJoypadButton and preferred_input_source != PreferredInputSource.JOYPAD:
		preferred_input_source = PreferredInputSource.JOYPAD
		print("Joypad button pressed. Changing preferred input method to joypad...")
	elif event is InputEventJoypadMotion and preferred_input_source != PreferredInputSource.JOYPAD:
		if abs(event.axis_value) > joypad_dead_zone:
			preferred_input_source = PreferredInputSource.JOYPAD
			print("Gamepad axis exceeded deadzone. Changing preferred input method to joypad...")
	
	if event.is_action_pressed("simulate_damage"):
		emit_signal("finished", "stagger")

func get_input_direction():
	var input_direction = Vector2()
	
	match preferred_input_source:
		PreferredInputSource.KEYBOARD:
			input_direction.x = int(Input.is_action_pressed("key_move_right")) - \
				int(Input.is_action_pressed("key_move_left"))
			input_direction.y = int(Input.is_action_pressed("key_move_down")) - \
				int(Input.is_action_pressed("key_move_up"))
		PreferredInputSource.JOYPAD:
			input_direction.x = int(Input.is_action_pressed("joypad_move_right")) - \
				int(Input.is_action_pressed("joypad_move_left"))
			input_direction.y = int(Input.is_action_pressed("joypad_move_down")) - \
				int(Input.is_action_pressed("joypad_move_up"))
	
	return input_direction

func update_look_direction(direction):
	if direction and owner.look_direction != direction:
		owner.look_direction = direction
