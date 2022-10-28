extends CharacterBody2D

@export var controllable:bool
@export var cell = Vector2i(-1, -1):
	set(value):
		if battle_field.cell_to_atom.get(cell) == self:
			battle_field.cell_to_atom.erase(cell)
		cell = value
		if $StateMachine.state.name == "idle":
			position = battle_field.map_to_local(cell)
		battle_field.insert_cell_to_atom(cell, self)


@onready var battle_field:TileMap = owner.get_node("BattleField")
@onready var property:Node = $Property

signal attack_finished


var _path = []

var _next_cell_pos = Vector2()
var destination:
	set(value):
		if destination==null or (battle_field.local_to_map(destination) != battle_field.local_to_map(value)):
			destination = battle_field.map_to_local(battle_field.local_to_map(value))
			_path = battle_field.get_astar_path(position, value)
			_update_path()


func set_path(value):
	battle_field.clear_previous_path_drawing()
	_path = value
	_update_path()
	battle_field._map_path = []
	battle_field.queue_redraw()

func _update_path():
	if _path.size() == 0:
		$StateMachine.transit_to("idle")
		return
	_next_cell_pos = _path[0]
	turn(_next_cell_pos)

func _ready():
	_reset_pos()
	

func _reset_pos():
	if cell == Vector2i(-1,-1):
		cell = battle_field.local_to_map(position)
#	position = battle_field.map_to_local(cell)
#	battle_field.insert_cell_to_atom(cell, self)

func _process(_delta):
#	print(property.status)
	if property.status.get_final_var("life") == property.status.get_final_min("life"):
		die()
	queue_redraw()

func _physics_process(_delta):
#	Common.print_with_time(controllable)
#	print(battle_field.local_to_map(position), battle_field.local_to_map_float(position))
	pass

func _draw():
	if controllable:
		draw_arc($Piece.position, 90, 0, 2*3.15, 90, Color.WHITE, 10, true)


func attack(target):
	var timer:SceneTreeTimer
	timer = get_tree().create_timer(property.attack.get_final_var("foreswing"))
#	print_debug("begin foreswing")
	#foreswing animation
	await timer.timeout
	match property.attack.get_final_var("target_type"):
		"unit":
			var projectile = property.attack.get_final_var("projectile")
#			print_debug(projectile)
			if projectile == 0:
#				print_debug(self, target)
				target.under_attack(self, $Property.attack.get_final_var("damage"))
		"cell":
			pass
		_:
			printerr("unknow attack mode %s"%property.attack.get_final_var("mode"))
	timer = get_tree().create_timer(property.attack.get_final_var("backswing"))
#	print_debug("begin backswing")
	#backswing animation
	await timer.timeout
	
	timer = get_tree().create_timer(property.attack.get_final_var("idle"))
	await timer.timeout
#	print_debug("attack fininshed")
	emit_signal("attack_finished")


func under_attack(_attacker, attack_damage):
	print_debug("under_attack")
	print_debug("before damage: ", property.status.get_var("life"), " ",  property.status.get_final_var("life"))
	print(property.status.get_final_var("life") - attack_damage)
	property.status.set_var("life", property.status.get_final_var("life") - attack_damage)
	print_debug("after damage: ", property.status.get_var("life"), " ", property.status.get_final_var("life"))
	$HealthBar.value = property.status.get_final_var("life")

func die():
	$StateMachine.transit_to("idle")
	battle_field.cell_to_atom.erase(cell) # clear record in cell_to_atom 

	queue_free()
	

func turn(aim):
	$Piece.rotation = -Vector2(aim.y-position.y, aim.x-position.x).angle()


func move(aim):
	var dt = get_physics_process_delta_time()
	if position.distance_to(aim) > dt * property.speed:  
#			print("before move pos ",position)
		set_velocity(position.direction_to(aim) * property.speed)
		set_position(position + velocity * dt )
	else:
		set_position(aim)


func move_destination():
	move(_next_cell_pos)
	var distance_to_dst = position.distance_to(_next_cell_pos)
	if distance_to_dst < battle_field.tile_set.tile_size.x /2.:
		cell = battle_field.local_to_map(_next_cell_pos)
		if distance_to_dst == 0:
			_path.remove_at(0) 
			_update_path()



func receive_command(command_name: String, command_info: Dictionary = {}) -> void:
	$StateMachine.state.receive_command(command_name, command_info)

#func update_cell() -> void:
#	battle_field.cell_to_atom.erase(cell)
#	cell = battle_field.local_to_map(position)
#	position = battle_field.map_to_local(cell)
#	battle_field.insert_cell_to_atom(cell, self)

func is_in_range(target_cell, r, type="manhattan") -> bool:
#	print(Common.distance_grid_2d(cell, target_cell, type))
	if Common.distance_grid_2d(cell, target_cell, type) <= r:
		return true
	else:
		return false

func is_in_cell_center() -> bool:
	if position.distance_to(battle_field.map_to_local(cell)) == 0:
		return true
	else:
		return false
