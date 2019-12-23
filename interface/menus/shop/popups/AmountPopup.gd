extends Menu

signal amount_confirmed(value)

onready var popup = $Popup
onready var slider = $Popup/VBoxContainer/Slider/HSlider
onready var label = $Popup/VBoxContainer/Slider/Amount


"""args: {value, max_value}"""
func initialize(args={}):
	assert(args.size() == 2)
	var value = args['value']
	var max_value = args['max_value']
	label.initialize(value, max_value)
	slider.initialize(value, max_value)
	slider.grab_focus()

func open(args={}):
	popup.popup_centered()
	.open()
	var amount = yield(self, "amount_confirmed")
	close()
	return amount

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		emit_signal("amount_confirmed", 0)
		accept_event()
	elif event.is_action_pressed("ui_accept"):
		emit_signal("amount_confirmed", slider.value)
		accept_event()
