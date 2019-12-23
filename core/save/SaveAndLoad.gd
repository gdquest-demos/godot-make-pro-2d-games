extends Node

signal game_saved(id)
signal game_loaded(id)

onready var GAME_VERSION = ProjectSettings.get_setting("application/config/version")
var SAVE_DIRECTORY = "res://save/" if ProjectSettings.get_setting("application/config/debug") else "res://user/"
const SAVE_FILE_EXT = ".game"

func save_game(id):
	var save_data = {
		"version": GAME_VERSION,
		"data": []
	}
	# Get nodes in group works in tree order, from top to bottom
	# So we are guaranteed to get the parent first
	for node in get_tree().get_nodes_in_group("save"):
		var node_save_data = node.get_save_data()
		assert(node_save_data["filename"] != "")
		assert(node_save_data["parent"] != "")
		save_data["data"].append(node_save_data)

	var directory = Directory.new()
	if not directory.dir_exists(SAVE_DIRECTORY):
		directory.make_dir_recursive(SAVE_DIRECTORY)

	var path = get_save_file_path(id)
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(to_json(save_data))
	file.close()
	emit_signal("game_saved", id)

func load_game(id):
	var path = get_save_file_path(id)
	var file = File.new()
	if not file.file_exists(path):
		print("Couldn't load: file %s does not exist." % path)
		return
	file.open(path, File.READ)
	var save_data = parse_json(file.get_as_text())
	file.close()

	for node in get_tree().get_nodes_in_group("save"):
		node.queue_free()

	for node_data in save_data["data"]:
		var node = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(node)
		var properties = node_data["properties"]
		for property in properties.keys():
			var value
			if is_vector_2(property, node):
				value = parse_vector_2(properties[property])
			else:
				value = properties[property]
			node.set(property, value)
	emit_signal("game_loaded", id)

func get_save_file_path(id):
	return SAVE_DIRECTORY + str(id) + SAVE_FILE_EXT

func is_vector_2(property_name, node):
	return typeof(node.get(property_name)) == typeof(Vector2())

func parse_vector_2(json_string):
	var numbers_string = json_string.substr(1, len(json_string) - 2)
	var comma_position = numbers_string.find(",")
	var value_x = float(numbers_string.left(comma_position))
	var value_y = float(numbers_string.right(comma_position + 1))
	return Vector2(value_x, value_y)
