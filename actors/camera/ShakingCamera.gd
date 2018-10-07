extends Camera2D

export(float) var amplitude = 6.0
#export(float) var duration = 1.0 setget set_duration

enum STATES {IDLE, SHAKING}
var state = IDLE

func _ready():
	set_process(false)
	randomize()

func start_shake():
	_change_state(SHAKING)

func _change_state(new_state):
	match new_state:
		IDLE:
			offset = Vector2()
			set_process(false)
		SHAKING:
			set_process(true)
			$ShakeTimer.start()
	state = new_state

func _process(delta):
	offset = Vector2(
		rand_range(amplitude, -amplitude),
		rand_range(amplitude, -amplitude))

func _on_ShakeTimer_timeout():
	_change_state(IDLE)

func _on_WildBoar_phase_changed(new_phase_name):
	start_shake()
