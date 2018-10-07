extends "../Menu.gd"

export(PackedScene) var BuyMenu = preload("menus/BuySubMenu.tscn")
export(PackedScene) var SellMenu = preload("menus/SellSubMenu.tscn")

onready var buttons = $Column/Buttons
onready var submenu = $Column/Menu

# To test from ShopMenu.tscn
#func _ready():
#	var shop = load("res://shop/Shop.tscn").instance()
#	var player = load("res://actors/characters/player/Player.tscn").instance()
#	open(shop, player)

func open(shop, buyer):
	$Column/Buttons/BuyButton.connect("pressed", self, "opensubmenu",
		[BuyMenu, shop, buyer, shop.inventory])
	$Column/Buttons/SellButton.connect("pressed", self, "opensubmenu",
		[SellMenu, shop, buyer, buyer.get_node("Inventory")])
	buttons.get_child(0).grab_focus()
	.open()

func close():
	queue_free()
	.close()

func opensubmenu(Menu, shop, buyer, inventory):
	var pressed_button = get_focus_owner()
	
	var active_menu = Menu.instance()
	submenu.add_child(active_menu)
	active_menu.initialize(shop, buyer, inventory.get_items())
	set_process_input(false)
	active_menu.open()
	yield(active_menu, "closed")
	set_process_input(true)
	pressed_button.grab_focus()

func _on_QuitButton_pressed():
	close()
