extends State



var target = null

@onready var is_attacking = false


func enter(msg := {}) -> void:
	owner.destination = msg["destination"]
	target = msg["target"]


#func input(_event: InputEvent) -> void:
#	pass


func get_enemies_within_range(r, type: String ="manhattan"):
	var res = []
	for atom in owner.battle_field.get_atoms_within_range(owner.cell, r, type):
		if atom != owner:
			res.append(atom)
	return res
	

#func find_enemy_in_range():
#	var space = owner.get_world_2d().direct_space_state
#	var query = PhysicsShapeQueryParameters2D.new()
#	var range_circle = CircleShape2D.new()
#	range_circle.radius = owner.property.attack.range * owner.scale.y
#	query.set_shape(range_circle)
#	query.transform = Transform2D(0, owner.position)
#	var selected = space.intersect_shape(query)
#	for item in selected:
#		if item.collider != owner:
#			return item.collider
#	return null


func do_attack():
	Common.print_with_time("do an attack")
#	var timer:SceneTreeTimer = get_tree().create_timer(owner.property.attack.time)
	is_attacking=true
	owner.attack()
#	owner.get_node("Body/Weapon").attack()
#	await owner.get_node("Body/Weapon").attack.finished
#	Common.print_with_time("finish_attack")
#	await timer.timeout
	is_attacking = false



func physics_process(_delta) -> void:
	if not owner.property.attack.enable:
#		print(owner," can't attack")
		state_machine.transit_to("idle")
		return
	if is_attacking:
		return
	if target:
#		print("target: ",target)
		if not is_instance_valid(target):
			state_machine.transit_to("idle")
		else:
			owner.destination = target.position
#			print(owner)
#			print(owner.get_index())
#			for d in owner.get_property_list():
#				print("> " + d["name"])
			if owner.is_in_cell_center():
				if owner.is_in_range(target.cell, owner.property.attack.max_range): #TODO: a bug
					do_attack()
					return 
	else:
		var enemies = get_enemies_within_range(owner.property.attack.max_range)
		if enemies:
			if owner.is_in_cell_center():
				owner.turn(enemies[0].position) # set the first enemy as default
				do_attack()
				return
		else:
			if owner.position.distance_to(owner.destination) < 5:
				state_machine.transit_to("idle")
				return
	owner.move_destination()

	
		
func receive_command(command_name: String, command_info: Dictionary = {}) -> void:
	match command_name:
		"stop":
			state_machine.transit_to("stop")
		"move":
			state_machine.transit_to("move", command_info)
		"attack":
			pass
