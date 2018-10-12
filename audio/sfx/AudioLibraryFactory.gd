tool
extends EditorScript

func _run():
	var interface = get_editor_interface()
	var filesys = interface.get_resource_filesystem()
	
	"""
	Gets the directory for the source files, i.e. the .ogg samples
	This can be hardcoded, but in the current iteration it is got by
	adding res://audio/sfx/SoundEffectLibrary.gd to the root node and defining
	the directory using the inspector
	"""
	var dir = filesys.get_filesystem_path(get_scene().source_directory)
	
	for f in dir.get_file_count():
		var path = dir.get_file_path(f)
		if not filesys.get_file_type(path) == "AudioStreamOGGVorbis":
			continue
		
		var n = AudioStreamPlayer.new()
		var node_name = dir.get_file(f)
		node_name = node_name.replace(".ogg", "")
		n.name = node_name
		
		var stream = AudioStreamRandomPitch.new()
		stream.audio_stream = load(path)
		
		var stream_path = dir.get_file(f)
		stream_path = stream_path.replace(".ogg", ".tres")
		ResourceSaver.save(dir.get_parent().get_path() + stream_path, stream)
		
		get_scene().add_child(n)
		n.stream = stream
		n.owner = get_scene()
