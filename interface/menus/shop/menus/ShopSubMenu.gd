extends Menu

export(String, "sell_to", "buy_from") var ACTION = ""

onready var items_list = $Column/Row/ShopItemsList
onready var description_panel = $Column/DescriptionPanel
onready var info_panel = $Column/Row/InfoPanel
onready var amount_popup = items_list.get_node("AmountPopup")

func _ready():
	assert(ACTION != "")

"""Args: {shop, buyer, items}"""
func initialize(args={}):
	assert(args.size() == 3)
	# Extract the nodes from the args dict to preserve legacy code below
	var shop = args['shop']
	var items = args['items']
	var buyer = args['buyer']
	
	var purse = buyer.get_purse()
	info_panel.initialize(purse)

	for item in items:
		var price = shop.get_buy_value(item) if ACTION == "buy_from" else item.price
		var item_button = items_list.add_item_button(item, price, purse)

		item_button.connect("pressed", self, "_on_ItemButton_pressed", [shop, buyer, item])
		item_button.connect("pressed", info_panel, "_on_focused_Item_amount_changed", [item])
	items_list.connect("focused_button_changed", self, "_on_ItemList_focused_button_changed")
	items_list.initialize()

func _on_ItemList_focused_button_changed(item_button):
	description_panel.display(item_button.description)

func open(args={}):
	.open()
	items_list.get_child(0).grab_focus()

func close():
	.close()
	queue_free()

func _on_ItemButton_pressed(shop, buyer, item):
	var price = shop.get_buy_value(item) if ACTION == "buy_from" else item.price
	var coins = shop.get_purse().coins if ACTION == "buy_from" else buyer.get_purse().coins
	var max_amount = min(item.amount, floor(coins / price))

	var focused_item = get_focus_owner()
	amount_popup.initialize({'value': 1, 'max_value': max_amount})
	var amount = yield(amount_popup.open(), "completed")
	focused_item.grab_focus()
	if not amount:
		return
	shop.call(ACTION, buyer, item, amount)
