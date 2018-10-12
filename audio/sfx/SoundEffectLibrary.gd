extends Node

export (String, DIR) var source_directory

func play(sfx_name = null):
	if not sfx_name:
		var index = randi()%(get_child_count() -1)
		var sfx = get_child(index)
		sfx.play()
	else:
		get_node(sfx_name).play()
		
func _ready():
	randomize()