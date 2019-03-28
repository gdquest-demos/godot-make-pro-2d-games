extends "res://actors/DamageSource.gd"

signal combo_finished()

enum States { IDLE, ATTACK }
var state = null

enum AttackInputStates { WAITING, LISTENING, REGISTERED }
var attack_input_state = AttackInputStates.WAITING
var ready_for_next_attack = false

var attack_id = 0
var combo = [
	{
		'damage': 1,
		'animation': 'attack_fast',
	},
	{
		'damage': 1,
		'animation': 'attack_fast',
	},
	{
		'damage': 3,
		'animation': 'attack_medium',
	}]

func _ready():
	$AnimationPlayer.connect('animation_finished', self, "_on_animation_finished")
	_change_state(States.IDLE)

func _change_state(new_state):
	match state:
		States.IDLE:
			visible = true
	match new_state:
		States.IDLE:
			attack_id = 0
			visible = false
		States.ATTACK:
			attack_input_state = AttackInputStates.WAITING
			ready_for_next_attack = false
			var attack = combo[min(attack_id, combo.size() - 1)]
			damage = attack['damage']
			$AnimationPlayer.play(attack['animation'])
			attack_id += 1
	state = new_state

func _input(event):
	if not state == States.ATTACK:
		return
	if attack_input_state != AttackInputStates.LISTENING:
		return
	if event.is_action_pressed('attack'):
		attack_input_state = AttackInputStates.REGISTERED

func _physics_process(delta):
	if attack_input_state == AttackInputStates.REGISTERED and ready_for_next_attack:
		attack()

func attack():
	_change_state(States.ATTACK)

# use with AnimationPlayer func track
func set_attack_input_listening():
	attack_input_state = AttackInputStates.LISTENING

# use with AnimationPlayer func track
func set_ready_for_next_attack():
	ready_for_next_attack = true

func _on_animation_finished(name):
	if attack_input_state == AttackInputStates.REGISTERED and attack_id < combo.size():
		attack()
	else:
		_change_state(States.IDLE)
		emit_signal("combo_finished")
