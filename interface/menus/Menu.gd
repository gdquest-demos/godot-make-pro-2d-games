extends Control

signal open()
signal closed()

export(NodePath) var SUB_MENU_PATH
onready var audio_player = $AudioStreamPlayer

func _ready():
	set_process_input(false)

func open():
	emit_signal("open")
	set_process_input(true)
	show()
	audio_player.play_popup_open()

func close():
	emit_signal("closed")
	set_process_input(false)
	hide()
	audio_player.play_confirm()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()

# You can streamline opening sub menus with these methods
# The main drawback is you lose the initialize method's signature
# Instead you have to group the arguments in an array
func initialize(args=[]):
	return

func open_sub_menu(menu, args=[]):
	var sub_menu = menu.instance()
	if SUB_MENU_PATH:
		get_node(SUB_MENU_PATH).add_child(sub_menu)
	else:
		add_child(sub_menu)
	sub_menu.initialize(args)

	set_process_input(false)
	sub_menu.open()
	yield(sub_menu, "closed")
	set_process_input(true)
