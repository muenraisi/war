extends Button

var description = ""

func initialize(item):
	$Name.text = item.display_name
	$Amount.text = str(item.amount)
	$Icon.texture = item.icon
	
	description = item.description
	
	disabled = not item.usable
	
	item.connect("amount_changed",Callable(self,"_on_Item_amount_changed"))
	item.connect("depleted",Callable(self,"queue_free"))

func _on_Item_amount_changed(amount):
	$Amount.text = str(amount)
