extends Control

signal closed(selected_actor)

export(PackedScene) var ActorButton

func _ready():
	set_as_toplevel(true)
	for actor in get_tree().get_nodes_in_group("actor"):
		create_actor_button(actor)

func create_actor_button(actor):
	var button = ActorButton.instance()
	button.get_node("Name").text = actor.name
	button.connect("pressed", self, "_on_SelectButton_pressed", [actor])
	$ActorsList.add_child(button)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()

func _on_SelectButton_pressed(actor):
	close(actor)

func open():
	$ActorsList.get_child(0).grab_focus()
	visible = true
	set_process_input(true)

func close(selected_actor=null):
	visible = false
	set_process_input(false)
	emit_signal("closed", selected_actor)
	
