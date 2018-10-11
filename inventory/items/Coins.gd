tool
extends Area2D

const CoinsCollector = preload("res://actors/CoinsCollector.gd")

export(int) var amount = 1 setget set_amount
export(float) var MAX_START_VERTICAL_THRUST = 400.0
export(float) var MAX_HORIZONTAL_SPEED = 200.0
export(float) var GRAVITY = 2000.0
export(float) var STOP_THRESHOLD_VERTICAL_SPEED = 3.0
export(float, 0.0, 1.0) var DAMPING_FACTOR = 0.6

var direction = Vector2()
var speed_horizontal = 0.0
var speed_vertical = 0.0
var height = 0.0 setget set_height

func set_amount(value):
	amount = value
	# TODO: update the texture based on the amount

func _on_area_entered(area):
	if not area is CoinsCollector:
		return
	queue_free()

func _ready():
	set_process(false)
	if Engine.editor_hint:
		return
	throw()

func throw():
	var rand_angle = randf() * 2 * PI
	direction = Vector2(
		cos(rand_angle),
		sin(rand_angle))
	speed_vertical = (randf() * 0.5 + 0.5) * MAX_START_VERTICAL_THRUST
	speed_horizontal = (randf() * 0.8 + 0.2) * MAX_HORIZONTAL_SPEED
	$Timer.wait_time = rand_range(1.0, 2.0)
	$Timer.start()
	set_process(true)

func _process(delta):
	self.height += speed_vertical * delta
	if height < 0:
		speed_vertical = -speed_vertical * DAMPING_FACTOR
		height = -height
		if abs(speed_vertical) < STOP_THRESHOLD_VERTICAL_SPEED:
			speed_vertical = 0.0
			height = 0.0
			set_process(false)
	speed_vertical -= GRAVITY * delta
	var speed_scale = $Timer.time_left / $Timer.wait_time
	position += speed_horizontal * direction * delta * speed_scale

func set_height(value):
	height = value
	if is_processing():
		$coins.position.y = -height
