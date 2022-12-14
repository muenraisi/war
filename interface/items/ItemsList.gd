extends Control

signal focused_button_changed(button)
signal item_amount_changed(amount)
signal focused_item_changed(item)

@export var ItemButton: PackedScene = preload("res://interface/items/ItemButton.tscn")
@onready var _grid = $Grid

func initialize():
	_grid.initialize()

func add_item_button(item, price, purse):
	var item_button = ItemButton.instantiate()
	item_button.initialize(item, price, purse)
	_grid.add_child(item_button)
	item_button.connect("focus_entered",Callable(self,"_on_ItemButton_focus_entered").bind(item_button, item))
	item_button.connect("amount_changed",Callable(self,"_on_ItemButton_amount_changed"))
	return item_button

func _gui_input(event):
	if not get_viewport().gui_get_focus_owner() == self:
		return
	if event.is_action_pressed('ui_left') or \
		event.is_action_pressed('ui_right') or \
		event.is_action_pressed('ui_up') or \
		event.is_action_pressed('ui_down'):
		$MenuSfx/Navigate.play()
		accept_event()

func get_item_buttons():
	return _grid.get_children()

func _on_ItemButton_focus_entered(button, item):
	emit_signal("focused_button_changed", button)
	emit_signal("focused_item_changed", item)

func _on_ItemButton_amount_changed(value):
	emit_signal("item_amount_changed", value)
