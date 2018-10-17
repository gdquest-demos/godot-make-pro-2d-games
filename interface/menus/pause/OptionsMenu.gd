extends "res://interface/menus/Menu.gd"

onready var first_slider = $Column/MusicController/Row/HSlider

func open():
	.open()
	first_slider.grab_focus()

func close():
	queue_free()
	.close()
