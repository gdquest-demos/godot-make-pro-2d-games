tool
extends Particles2D

export(bool) var active = true setget set_active

func set_active(value):
	active = value
	emitting = value
	for child in get_children():
		if not child.get_class() == "Particles2D":
			continue
		child.emitting = value
