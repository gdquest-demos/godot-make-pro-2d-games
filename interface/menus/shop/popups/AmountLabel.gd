extends Label

var _max_value

func initialize(value, max_value):
	_max_value = max_value
	update_text(value)

func update_text(value):
	text = "%s/%s" % [value, _max_value]

func _on_HSlider_value_changed(value):
	update_text(value)
