extends AudioStreamPlayer

# In Godot 3.1 you can export the Array instead
var samples = [
	preload("res://audio/sfx/step_01.wav"),
	preload("res://audio/sfx/step_02.wav")
]

func _ready():
	randomize()

func play_random():
	# In Godot 3.1 you can use Array.shuffle() after going through the sounds
	stream = samples[randi() % samples.size()]
	play()
