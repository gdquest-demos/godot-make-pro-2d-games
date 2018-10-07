extends ColorRect

onready var anim_player = $AnimationPlayer

func fade_to_color():
	show()
	anim_player.play("to_color")
	yield(anim_player, "animation_finished")
	hide()

func fade_from_color():
	show()
	anim_player.play("to_transparent")
	yield(anim_player, "animation_finished")
	hide()
