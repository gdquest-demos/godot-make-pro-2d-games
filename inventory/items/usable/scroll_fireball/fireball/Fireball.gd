extends Area2D

export(PackedScene) var Explosion
export(float) var SPEED = 1000.0
var direction = Vector2(1, 0)

func _physics_process(delta):
	position += direction * SPEED * delta

func _on_body_entered(body):
	explode()

func _on_area_entered(area):
	explode()

func explode():
	set_active(false)
	
	var explosion_node = Explosion.instance()
	add_child(explosion_node)
	get_tree().create_timer(explosion_node.lifetime * 2.0).connect("timeout", self, "queue_free")

func set_active(value):
	set_physics_process(value)
	$CollisionShape2D.disabled = value
	$Fireball.active = value
