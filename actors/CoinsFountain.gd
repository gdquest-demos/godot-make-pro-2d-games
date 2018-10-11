extends Position2D

const Coins = preload("res://inventory/items/Coins.tscn")
var coin_values = [10, 20, 50, 100]

onready var timer = $Timer

export(int) var MAX_SPAWN_COUNT = 12
var spawn_cycles = 0

func start():
	timer.start()

func _on_Timer_timeout():
	spawn_random_coin_stack()

func spawn_random_coin_stack():
	var coins = Coins.instance()
	coins.amount = randi() % coin_values.size()
	add_child(coins)
	coins.throw()
	spawn_cycles += 1
	if spawn_cycles == MAX_SPAWN_COUNT:
		timer.stop()
