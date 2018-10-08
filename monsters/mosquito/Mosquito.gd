extends '../Monster.gd'

enum STATES { IDLE, RETURN, SPOT, FOLLOW, ORBIT, STAGGER, ATTACK_COOLDOWN, DIE, DEAD}

export(float) var FOLLOW_RANGE = 300.0
export(float) var MAX_FLY_SPEED = 360.0
export(float) var MAX_ROTATION_STEP = 20.0

func _ready():
	_change_state(IDLE)

func _change_state(new_state):
	match state:
		ATTACK_COOLDOWN:
			$CollisionPolygon2D.disabled = false

	match new_state:
		IDLE:
			pass
		ATTACK_COOLDOWN:
			$CollisionPolygon2D.disabled = true
			queue_free()
			emit_signal('died')
	state = new_state

func _physics_process(delta):
	var current_state = state
	match current_state:
		IDLE:
			if position.distance_to(target.position) <= FOLLOW_RANGE:
				_change_state(FOLLOW)
		FOLLOW:
			if position.distance_to(target.position) > FOLLOW_RANGE:
				_change_state(RETURN)
				return

			velocity = Steering.follow(velocity, position, target.position, MAX_FLY_SPEED)
			move_and_slide(velocity)
			rotation = velocity.angle()

			if get_slide_count() == 0:
				return
			var body = get_slide_collision(0).collider
			if body.is_in_group('character'):
				body.take_damage(self, 4)
				_change_state(ATTACK_COOLDOWN)
		RETURN:
			velocity = Steering.arrive_to(velocity, position, start_position)
			move_and_slide(velocity)
			rotation = velocity.angle()

			if position.distance_to(start_position) < ARRIVE_DISTANCE:
				_change_state(IDLE)
