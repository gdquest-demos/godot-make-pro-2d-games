extends Menu

onready var items_list = $Column/ItemsMenu

"""args: {inventory}"""
func initialize(args={}):
	items_list.initialize(args['inventory'])

"""args: {inventory}"""
func open(args={}):
	assert(args.size() == 1)
	var inventory = args['inventory']
	.open()

func close():
	.close()
	queue_free()
