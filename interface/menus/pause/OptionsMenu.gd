extends Menu

const SoundController = preload("res://interface/menus/pause/SoundController.gd")

onready var first_slider = $Column/MusicController/Row/HSlider

func open(args={}):
	.open()
	first_slider.grab_focus()
	set_focus_neighbors()

func set_focus_neighbors():
	"""
	Loops through the sliders and assign their focus neighbors manually
	This fixes keyboard navigation in the options menu
	"""
	var sliders = get_sound_sliders()
	var index = 0
	for slider in sliders:
		var index_previous = index - 1
		if index_previous >= 0:
			slider.focus_neighbour_top = slider.get_path_to(sliders[index_previous])
		var index_next = index + 1
		if index_next < sliders.size():
			slider.focus_neighbour_bottom = NodePath(slider.get_path_to(sliders[index_next]))
		index += 1

	var back_button = $Column/GoBackButton
	var last_slider = sliders[-1]
	last_slider.focus_neighbour_bottom = last_slider.get_path_to(back_button)
	back_button.focus_neighbour_top = back_button.get_path_to(last_slider)

func get_sound_sliders():
	var sliders = []
	for node in $Column.get_children():
		if not node is SoundController:
			continue
		sliders.append(node.slider)
	return sliders
