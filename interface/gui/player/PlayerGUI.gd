extends Control

signal health_updated(value)

func _ready():
	var health_node = null
	for node in get_tree().get_nodes_in_group("actor"):
		if node.name == "Player":
			health_node = node.get_node("Health")
			break
	get_node("LifeBar").initialize(health_node.health, health_node.max_health)

func _on_Health_health_changed(health):
	emit_signal("health_updated", health)

func _on_Health_health_depleted():
	$AnimationPlayer.play("fade_out")
