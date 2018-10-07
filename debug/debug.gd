extends Node

signal debug_toggled

var debug = false setget _set_debug


func _ready():
	debug = ProjectSettings.get_setting('Debug/debug_mode')


func _input(event):
	if event.is_action_pressed('debug'):
		self.debug = not debug


func _set_debug(value):
	debug = value
	ProjectSettings.set_setting('Debug/debug_mode', value)
	emit_signal('debug_toggled',value)
