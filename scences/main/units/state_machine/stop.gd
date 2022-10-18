extends State

var idle_pos
# direct control by input event
#func input(event: InputEvent) -> void:
#	if owner.controllable:
#		if event.is_action_pressed("right_click"):
#			var mouse_pos = owner.get_global_mouse_position()
#			# get the PhysicsDirectSpaceState2D object
#			var space = owner.get_world_2d().direct_space_state
#			# Get the mouse's position
#			# Check if there is a collision at the mouse position
#			var intersect_object = space.intersect_point(mouse_pos, 1)
#			var destination = mouse_pos
#			if intersect_object:
#				destination  = intersect_object[0].collider.position
#		#		print("destination: ", destination)
#			state_machine.transit_to("move", {destination = destination})
#		if owner.has_weapon and event.is_action_pressed("attack"):
#			var destination
#			if event.is_action_pressed("right_click"):
#				destination = owner.get_global_mouse_position()  # MUST NOT using event.position
#			else:
#				destination = null
#		#		print("destination: ", destination)
#			state_machine.transit_to("attack", {"destination":destination})

func enter(_msg := {}) -> void:
#	print(owner._path)
#	print(owner.destination)
	if owner.position != owner.battle_field.map_to_local(owner.cell):
		owner.set_path([ owner.battle_field.map_to_local(owner.cell)])
#	print(owner._path)
#	print(owner.destination)

func physics_process(_delta):
#	print(owner.position, " ", destination, " ", owner.position.distance_to(destination))
	owner.move_destination()
#	if owner.position.distance_to(idle_pos) < owner.ARRIVE_DISTANCE:
#		owner.cell = owner.battle_field.local_to_map(idle_pos)


func receive_command(command_name: String, command_info: Dictionary = {}) -> void:
	match command_name:
		"stop":
			pass
		"move":
			state_machine.transit_to(command_name, command_info)
		"attack":
			state_machine.transit_to(command_name, command_info)
