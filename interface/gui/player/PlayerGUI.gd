extends Control

func initialize(health_node):
	get_node("LifeBar").initialize(health_node)
	health_node.connect('health_depleted', self, '_on_Player_Health_health_depleted')

func _on_Player_Health_health_depleted():
	$AnimationPlayer.play("fade_out")
