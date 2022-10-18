extends Control

signal closed(selected_actor)

@export var ActorButton: PackedScene

func _ready():
	set_as_top_level(true)

func initialize(actors):
	for actor in actors:
		create_actor_button(actor)

func create_actor_button(actor):
	var button = ActorButton.instantiate()
	button.get_node("Name").text = actor.name
	button.connect("pressed",Callable(self,"_on_SelectButton_pressed").bind(actor))
	$ActorsList.add_child(button)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		close()

func _on_SelectButton_pressed(actor):
	close(actor)

# TODO: Temporarily bypassing the menu, 
# see https://github.com/GDquest/make-pro-2d-games-with-godot/issues/66
func open():
	close()
	return
	$ActorsList.get_child(0).grab_focus()
	visible = true
	set_process_input(true)

func close(selected_actor=null):
	visible = false
	set_process_input(false)
	emit_signal("closed", selected_actor)
