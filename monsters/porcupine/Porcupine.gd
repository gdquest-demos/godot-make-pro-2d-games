tool
extends '../Monster.gd'

enum STATES { IDLE, ROAM, RETURN, SPOT, FOLLOW, PREPARE_TO_CHARGE, CHARGE, BUMP, BUMP_COOLDOWN, HIT_PLAYER_COOLDOWN, STAGGER, DIE, DEAD}

export(float) var MAX_ROAM_SPEED = 200.0
export(float) var MAX_FOLLOW_SPEED = 400.0
export(float) var MAX_CHARGE_SPEED = 900.0

export(float) var SPOT_RANGE = 460.0
export(float) var FOLLOW_RANGE = 700.0
export(float) var BUMP_RANGE = 90.0

export(float) var CHARGE_RANGE = 340.0
export(float) var PREPARE_TO_CHARGE_WAIT_TIME = 0.9

var charge_direction = Vector2()
var charge_distance = 0.0

export(float) var ROAM_RADIUS = 140.0

var roam_target_position = Vector2()
var roam_slow_radius = 0.0

export(float) var BUMP_DISTANCE = 60.0
export(float) var BUMP_DURATION = 0.2
export(float) var MAX_BUMP_HEIGHT = 50.0

export(float) var BUMP_COOLDOWN_DURATION = 0.6

func _ready():
	start_position = position
	if Engine.editor_hint:
		set_physics_process(false)
		return

	_change_state(IDLE)
	$Tween.connect('tween_completed', self, '_on_tween_completed')
	$AnimationPlayer.connect('animation_finished', self, '_on_animation_finished')
	$Timer.connect('timeout', self, '_on_Timer_timeout')

func _change_state(new_state):
	match state:
		IDLE:
			$Timer.stop()
		RETURN:
			$RayCast2D.visible = false
		FOLLOW:
			$RayCast2D.visible = false
		CHARGE:
			$DustPuffs.emitting = false

	match new_state:
		IDLE:
			randomize()
			$Timer.wait_time = randf() * 2 + 1.0
			$Timer.start()
		RETURN:
			$RayCast2D.visible = true
		ROAM:
			randomize()
			var random_angle = randf() * 2 * PI
			randomize()
			var random_radius = (randf() * ROAM_RADIUS) / 2 + ROAM_RADIUS / 2
			roam_target_position = start_position + Vector2(cos(random_angle) * random_radius, sin(random_angle) * random_radius)
			roam_slow_radius = roam_target_position.distance_to(start_position) / 2
		SPOT:
			$AnimationPlayer.play('spot')
		FOLLOW:
			$RayCast2D.visible = true
		PREPARE_TO_CHARGE:
			$Timer.wait_time = PREPARE_TO_CHARGE_WAIT_TIME
			$Timer.start()
		CHARGE:
			charge_direction = (target.position - position).normalized()
			charge_distance = 0.0
			$DustPuffs.emitting = true
		BUMP:
			$AnimationPlayer.stop()
			var bump_direction = (position - target.position).normalized()
			$Tween.interpolate_property(self, 'position', position, position + BUMP_DISTANCE * bump_direction, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.interpolate_method(self, '_animate_bump_height', 0, 1, BUMP_DURATION, Tween.TRANS_LINEAR, Tween.EASE_IN)
			$Tween.start()
		BUMP_COOLDOWN:
			randomize()
			get_tree().create_timer(BUMP_COOLDOWN_DURATION).connect('timeout', self, '_change_state', [FOLLOW])
	state = new_state

func _physics_process(delta):
	var current_state = state
	match current_state:
		IDLE:
			if not target:
				return
			if position.distance_to(target.position) < SPOT_RANGE:
				_change_state(SPOT)
		ROAM:
			velocity = Steering.arrive_to(velocity, position, roam_target_position, roam_slow_radius, MAX_ROAM_SPEED)
			move_and_slide(velocity)
			if position.distance_to(roam_target_position) < ARRIVE_DISTANCE:
				_change_state(IDLE)
			if not target:
				return
			elif position.distance_to(target.position) < SPOT_RANGE:
				_change_state(SPOT)
		RETURN:
			velocity = Steering.arrive_to(velocity, position, start_position, roam_slow_radius, MAX_ROAM_SPEED)
			move_and_slide(velocity)
			if position.distance_to(start_position) < ARRIVE_DISTANCE:
				_change_state(IDLE)
			elif position.distance_to(target.position) < SPOT_RANGE:
				_change_state(SPOT)
		FOLLOW:
			if not target:
				_change_state(RETURN)
				return
			velocity = Steering.follow(velocity, position, target.position, MAX_FOLLOW_SPEED)
			move_and_slide(velocity)

			if position.distance_to(target.position) < CHARGE_RANGE:
				_change_state(PREPARE_TO_CHARGE)

			if position.distance_to(target.position) > FOLLOW_RANGE:
				_change_state(RETURN)
		CHARGE:
			if charge_distance > 800.0:
				_change_state(BUMP_COOLDOWN)
				return

			velocity = charge_direction * MAX_CHARGE_SPEED
			charge_distance += velocity.length() * delta
			move_and_slide(velocity)

			# TODO: Replace with a HitBox
			if get_slide_count() > 0:
				var body = get_slide_collision(0).collider
				if body.get_name() == "Player":
					body.take_damage(self, 3)
				_change_state(BUMP)

func _on_animation_finished(name):
	if name == 'spot':
		_change_state(FOLLOW)

func _animate_bump_height(progress):
	$BodyPivot.position.y = -pow(sin(progress * PI), 0.4) * MAX_BUMP_HEIGHT

func _on_tween_completed(object, key):
	_change_state(BUMP_COOLDOWN)

func _on_Timer_timeout():
	match state:
		IDLE:
			_change_state(ROAM)
		PREPARE_TO_CHARGE:
			_change_state(CHARGE)
