extends "res://interface/menus/Menu.gd"

onready var first_slider = $Column/MusicController/Row/HSlider

func open(args):
	.open()
	first_slider.grab_focus()

func close():
	.close()
