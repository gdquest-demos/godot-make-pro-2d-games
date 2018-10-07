extends Node

signal health_changed(new_health)
signal health_depleted()

var modifiers = {}

export(int) var health = 0
export(int) var max_health = 9
export(int) var strength = 2
export(int) var defense = 0

func _ready():
	health = max_health

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	if health == 0:
		emit_signal("health_depleted")

func heal(amount):
	health += amount
	health = max(health, max_health)
	emit_signal("health_changed", health)

func add_modifier(id, modifier):
	modifiers[id] = modifier

func remove_modifier(id):
	modifiers.erase(id)
