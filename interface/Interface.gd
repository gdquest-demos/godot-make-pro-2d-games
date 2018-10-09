extends CanvasLayer

onready var shop_menu = $ShopMenu

func _ready():
	shop_menu.connect('closed', self, 'remove_child', [shop_menu])
	remove_child(shop_menu)

func _on_Level_loaded():
	for seller in get_tree().get_nodes_in_group('seller'):
		seller.connect('shop_open_requested', self, 'shop_open')

func shop_open(seller_shop, buyer):
	add_child(shop_menu)
	shop_menu.open(seller_shop, buyer)
