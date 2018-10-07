extends Node

export(PackedScene) var Lifebar

func _ready():
	for actor in get_tree().get_nodes_in_group("actor"):
		create_lifebar(actor)
	for spawner in get_tree().get_nodes_in_group("monster_spawner"):
		spawner.connect("spawned_monster", self, "_on_MonsterSpawner_spawned_monster")

func _on_MonsterSpawner_spawned_monster(monster_node):
	create_lifebar(monster_node)

func create_lifebar(actor):
	if not (actor.has_node("Health") and actor.has_node("InterfaceAnchor")):
		return
	var lifebar = Lifebar.instance()
	add_child(lifebar)
	lifebar.initialize(actor)
