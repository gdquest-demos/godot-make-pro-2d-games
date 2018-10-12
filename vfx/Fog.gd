extends ColorRect

func _on_LevelLoader_loaded(level):
	visible = level.fog
