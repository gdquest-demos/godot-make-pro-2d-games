extends Particles2D

func _ready():
	one_shot = true
	$SmallSparkles.one_shot = true
	get_tree().create_timer(lifetime * 2.0).connect('timeout', self, 'queue_free')
