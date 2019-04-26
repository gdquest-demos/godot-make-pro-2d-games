extends '../Monster.gd'

enum { IDLE, RETURN, SPOT, FOLLOW, DIE}

export(float) var FOLLOW_RANGE = 300.0
export(float) var MAX_FLY_SPEED = 360.0

func _ready():
	_change_state(IDLE)

func _change_state(new_state):
	match new_state:
		IDLE:
			pass
		DIE:
			queue_free()
			emit_signal('died')
	state = new_state

func _physics_process(delta):
	var current_state = state
	match current_state:
		IDLE:
			if not target:
				return
			if position.distance_to(target.position) <= FOLLOW_RANGE:
				_change_state(FOLLOW)
		FOLLOW:
			if not target:
				return
			if position.distance_to(target.position) > FOLLOW_RANGE:
				_change_state(RETURN)
				return

			velocity = Steering.follow(velocity, position, target.position, MAX_FLY_SPEED)
			move_and_slide(velocity)
			rotation = velocity.angle()
		RETURN:
			velocity = Steering.arrive_to(velocity, position, start_position)
			move_and_slide(velocity)
			rotation = velocity.angle()

			if position.distance_to(start_position) < ARRIVE_DISTANCE:
				_change_state(IDLE)

func _on_DamageSource_area_entered(area):
	_change_state(DIE)

func _on_Stats_damage_taken(new_health):
	_change_state(DIE)
