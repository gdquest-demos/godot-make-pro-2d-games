extends Control

func get_save_buttons():
	return $Row/SaveButtons.get_children()

func get_load_buttons():
	return $Row/LoadButtons.get_children()
