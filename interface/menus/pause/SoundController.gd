tool
extends Panel

onready var audio_bus_label = $Row/Label
onready var amount_label = $Row/Amount
onready var slider = $Row/HSlider

export(String, "Music", "World", "Interface") var BUS_NAME = "Music"
var audio_bus_index

func _ready():
	audio_bus_index = AudioServer.get_bus_index(BUS_NAME)
	audio_bus_label.text = BUS_NAME
	var volume_db = AudioServer.get_bus_volume_db(audio_bus_index)
	slider.value = round(min(db2linear(volume_db) * 100.0, 100.0))

func change_volume(value):
	var volume = max(linear2db(value / slider.max_value), -80.0)
	AudioServer.set_bus_volume_db(audio_bus_index, volume)
