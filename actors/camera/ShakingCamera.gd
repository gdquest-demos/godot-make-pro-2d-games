extends Camera2D

export(float) var amplitude = 6.0
export(float, EASE) var EASING_CURVE = 1.0

onready var timer = $Timer

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
			timer.start()
	state = new_state

func _process(delta):
	var damping = ease(timer.time_left / timer.wait_time, EASING_CURVE)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)

func _on_ShakeTimer_timeout():
	_change_state(IDLE)
