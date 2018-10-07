extends Node2D

var max_health = 0 setget set_max_health
var health = 0 setget set_health

func set_max_health(value):
	max_health = value
	$TextureProgress.max_value = value

func set_health(value):
	health = value
	$TextureProgress.value = value

func initialize(actor):
	if not (actor.has_node("Health") and actor.has_node("InterfaceAnchor")):
		return
	
	var hook = actor.get_node("InterfaceAnchor")
	global_position = hook.global_position
	hook.remote_path = hook.get_path_to(self)
	
	var health_node = actor.get_node("Health")
	health_node.connect("health_changed", self, "_on_Actor_health_changed")
	health_node.connect("health_depleted", self, "_on_Actor_health_depleted")
	
	self.health = health_node.health
	self.max_health = health_node.max_health

func _on_Actor_health_changed(new_health):
	self.health = new_health
	
func _on_Actor_health_depleted():
	queue_free()
