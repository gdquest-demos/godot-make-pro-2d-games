extends Node

signal health_changed(new_health)
signal damage_taken(new_health)
signal health_depleted()

var modifiers = {}

var health = 0
export(int) var max_health = 9 setget set_max_health
export(int) var strength = 2
export(int) var defense = 0

func _ready():
	health = max_health

func set_max_health(value):
	max_health = max(0, value)

func take_damage(amount):
	health -= amount
	health = max(0, health)
	emit_signal("health_changed", health)
	emit_signal("damage_taken", health)
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
