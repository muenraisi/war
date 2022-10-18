# Generic state machine. Initializes states and delegates engine callbacks
# (_physics_process, _unhandled_input) to the active state.
class_name StateMachine
extends Node

signal transited(next_state_name)



# Path3D to the initial active state. We export it to be able to pick the initial state in the inspector.
@export var start_state := NodePath()

# The current active state. At the start of the game, we get the `start_state`.
@onready var state: State = get_node(start_state)



func _ready() -> void:
	await owner.ready
#	print("state machine ready")
	# The state machine assigns itself to the State objects' state_machine property.
	for child in get_children():
		child.state_machine = self
	state.enter()


# The state machine subscribes to node callbacks and delegates them to the state objects.
func _input(event: InputEvent) -> void:
	state.input(event)

# The state machine subscribes to node callbacks and delegates them to the state objects.
func _unhandled_input(event: InputEvent) -> void:
	state.unhandled_input(event)

func _unhandled_key_input(event: InputEvent) -> void:
	state.unhandled_key_input(event)

func _process(delta: float) -> void:
	state.process(delta)
#	print(state.name, " process")

func _physics_process(delta: float) -> void:
	state.physics_process(delta)
#	print(state.name, "physics process")

func _notification(what) -> void:
	if is_instance_valid(state) and not owner.is_queued_for_deletion():
		state.notification(what)

func _on_animation_finished(anim_name):
	state._on_animation_finished(anim_name)




# This function calls the current state's exit() function, then changes the active state,
# and calls its enter function.
# It optionally takes a `msg` dictionary to pass to the next state's enter() function.
#func transition_to(target_next_state_name: String, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
func transit_to(next_state_name: String, msg: Dictionary = {}) -> void:
	
	if not has_node(next_state_name):
		print("Warn: ", next_state_name, " does not exists!")
		return
	
	state.exit()
	state = get_node(next_state_name)
	state.enter(msg)
	emit_signal("transited", state)
	print_debug("transited to ", next_state_name)

			
		
