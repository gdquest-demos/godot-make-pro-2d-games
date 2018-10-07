extends Control

signal maximum_changed(maximum)

var maximum = 100
var current_health = 0

func initialize(max_health, health):
	maximum = max_health
	emit_signal("maximum_changed", maximum)
	animate_bar(health)
	current_health = health

func _on_Interface_health_updated(new_health):
	animate_bar(new_health)
	current_health = new_health

func animate_bar(target_health):
	$TextureProgress.animate_value(current_health, target_health)
	$TextureProgress.update_color(target_health)
