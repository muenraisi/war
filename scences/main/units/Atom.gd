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

@onready var attack_affected = false

var face_direction = "up" #"up", "down", "left","right"

		
signal attack_finished
signal tactic_finished


@onready var spawn_number_template = preload("res://scences/main/units/SpawnNumber.tscn")
var damage_number_pool:Array[SpawnNumber] = []

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
		$StateMachine.transit_to("stop")
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
	if property.status.is_low("life"):
		die()
	if property.status.is_low("morale"):
		flee()
	queue_redraw()

func _physics_process(_delta):
#	Common.print_with_time(controllable)
#	print(battle_field.local_to_map(position), battle_field.local_to_map_float(position))
	pass

func _draw():
	if controllable:
		draw_arc($Piece.position, 60, 0, 2*3.15, 40, Color.RED, 2, false)


func attack(target):
	turn(target.position)
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
				var damage_computer =  BoardDamageComputer.new()
				damage_computer.set_attack(property.attack.get_final_var("power"), property.status.get_final_var("population"))
#				var attack_info = BoardAttackInfo.new(property.attack.get_final_var("power"))
				target.under_attack(self, damage_computer)
		"cell":
			pass
		_:
			printerr("unknow attack mode %s"%property.attack.get_final_var("mode"))
	attack_affected = true
	property.status.increase_var("tactic", property.attack.get_final_var("gain_tactic"))
	
	timer = get_tree().create_timer(property.attack.get_final_var("backswing"))
#	print_debug("begin backswing")
	#backswing animation
	await timer.timeout
	
	timer = get_tree().create_timer(property.attack.get_final_var("idle"))
	#left lime without animation
	await timer.timeout
	print_debug("attack fininshed")
	emit_signal("attack_finished")
	attack_affected = false


func tactic(_target):
	property.status.as_low("tactic")
	emit_signal("tactic_finished")
	pass


func under_attack(attacker, damage_computer:BoardDamageComputer):
#	print_debug("under_attack")
#	print_debug("before damage: ", property.status.get_var("life"), " ",  property.status.get_final_var("life"))
#	print_debug(property.status.get_final_var("life") - attack_damage)
	damage_computer.set_defend(property.defend.get_final_var("armor"))
	var attack_damage = damage_computer.compute()
	property.status.increase_var("life", -attack_damage)
#	print_debug(attacker.get_instance_id ())
	spawn_number_animate(attack_damage, Vector2(24, -24),  "damage", attacker.get_instance_id())
#	print_debug("lost life", attack_damage)
#	print_debug("life upp",property.status.get_final_upp("life"))
	print_debug("lost morale: ", property.morale.get_final_var("damage_life_ratio")  * attack_damage * 100 / property.status.get_final_upp("life"))
	property.status.increase_var("morale", -property.morale.get_final_var("damage_life_ratio")  * attack_damage * 100 / property.status.get_final_upp("life"))
	spawn_number_animate(property.morale.get_final_var("damage_life_ratio")  * attack_damage * 100 / property.status.get_final_upp("life"), Vector2(-24, -24), "morale",  attacker.get_instance_id())
#	print_debug("after damage: ", property.status.get_var("life"), " ", property.status.get_final_var("life"))


func die():
	print_debug("die")
	$StateMachine.transit_to("idle")
	battle_field.cell_to_atom.erase(cell) # clear record in cell_to_atom 
	queue_free()


func flee():
	print_debug("flee")
	$StateMachine.transit_to("idle")
	battle_field.cell_to_atom.erase(cell) # clear record in cell_to_atom 
	queue_free()
	

func turn(aim):
#	var rotation_angle = -Vector2(aim.y-position.y, aim.x-position.x).angle()
#	print_debug(Vector2.LEFT.angle()," ", Vector2.DOWN.angle()," ",Vector2.RIGHT.angle()," ", Vector2.UP.angle())
	var turn_direction = Vector2(aim.x-position.x, aim.y-position.y)
	if turn_direction.x > 0 and turn_direction.x > abs(turn_direction.y):
		face_direction = "right"
	elif turn_direction.x < 0 and -turn_direction.x > abs(turn_direction.y):
		face_direction = "left"
	elif turn_direction.y > 0 and turn_direction.y > abs(turn_direction.x):
		face_direction = "down"
	elif turn_direction.y < 0 and -turn_direction.y > abs(turn_direction.x):
		face_direction = "up"
	else:
		pass
	print_debug("turn to ",  face_direction, " with ", turn_direction)
#	$Piece.rotation = -Vector2(aim.y-position.y, aim.x-position.x).angle()
	

func stand():
	print_debug("stand with ", face_direction)
	if face_direction == "up":
		$AnimatedSprite2d.animation = "stand_up"
		$AnimatedSprite2d.flip_h = false
	elif face_direction == "down":
		$AnimatedSprite2d.animation = "stand_down"
		$AnimatedSprite2d.flip_h = false
	else:
		$AnimatedSprite2d.animation = "stand_left"
		if face_direction == "right":
			$AnimatedSprite2d.flip_h = true
		else:
			$AnimatedSprite2d.flip_h = false
			

func move(aim):
	var dt = get_physics_process_delta_time()
	if position.distance_to(aim) > dt * property.speed:  
#			print("before move pos ",position)
		set_velocity(position.direction_to(aim) * property.speed)
		set_position(position + velocity * dt )
	else:
		set_position(aim)


func move_destination() -> bool:
	var dest_cell = battle_field.local_to_map(_next_cell_pos)
	if dest_cell in battle_field.cell_to_atom.keys() and battle_field.cell_to_atom[dest_cell]!=self:
		print_debug(dest_cell, battle_field.cell_to_atom.keys(), battle_field.cell_to_atom[dest_cell], self)
		$StateMachine.transit_to("stop")
		return false
	move(_next_cell_pos)
	var distance_to_dst = position.distance_to(_next_cell_pos)
	if distance_to_dst < battle_field.tile_set.tile_size.x /2.:
		cell = dest_cell
		if distance_to_dst == 0:
			if _path.is_empty():
				return true
			else:
				_path.remove_at(0) 
				_update_path()
	return false	




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


func spawn_number_animate(number:float, pos:Vector2, label_type:String, id:int):
	var spawn_number = spawn_number_template.instantiate()
	add_child(spawn_number, true)
	spawn_number.set_number_and_animate(number, pos, 10, 10, id, label_type)

#func get_damage_number():
#	# get a damage number from the pool
#	if damage_number_pool.size() > 0:
#		return damage_number_pool.pop_front()
#
#	# create a new damage number if the pool is empty
#	else:
#		var new_damage_number = damage_number_template.instantiate()
#		print_debug(new_damage_number)
#		print_debug(typeof(new_damage_number))
#		new_damage_number.tree_exiting.connect(
#			func():damage_number_pool.append(new_damage_number))
#		return new_damage_number
