extends Menu

@export var BuyMenu: PackedScene = preload("menus/BuySubMenu.tscn")
@export var SellMenu: PackedScene = preload("menus/SellSubMenu.tscn")

@onready var buttons = $Column/Buttons
@onready var submenu = $Column/Menu

@onready var button_buy = $Column/Buttons/BuyButton
@onready var button_sell = $Column/Buttons/SellButton

func _ready():
	hide()


"""args: {shop, buyer}"""
func open(args={}):
	assert(args.size() == 2)
	var shop = args['shop']
	var buyer = args['buyer']
	
	button_buy.connect("pressed", self, "open_submenu",
		[BuyMenu, {
			'shop':shop,
			'buyer':buyer,
			'inventory':shop.inventory}])
	button_sell.connect("pressed", self, "open_submenu",
		[SellMenu, {
			'shop':shop,
			'buyer':buyer,
			'inventory':buyer.get_node("Inventory")}])
	super.open()
	buttons.get_child(0).grab_focus()

func close():
	button_buy.disconnect('pressed',Callable(self,'open_submenu'))
	button_sell.disconnect('pressed',Callable(self,'open_submenu'))
	super.close()


"""args: shop, buyer, inventory"""
func open_submenu(Menu, args={}):
	assert(args.size() == 3)
	var shop = args['shop']
	var buyer = args['buyer']
	var inventory = args['inventory']
	
	var pressed_button = get_viewport().gui_get_focus_owner()
	
	var active_menu = Menu.instantiate()
	submenu.add_child(active_menu)
	active_menu.initialize({'shop':shop, 'buyer':buyer, 'items':inventory.get_items()})
	set_process_input(false)
	active_menu.open()
	await active_menu.closed
	set_process_input(true)
	pressed_button.grab_focus()

func _on_QuitButton_pressed():
	close()
