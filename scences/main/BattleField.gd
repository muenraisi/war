extends TileMap


const BASE_LINE_WIDTH = 4.0
const DRAW_COLOR = Color.BLACK
const PATH_LAYER = 1 

# The Tilemap node doesn't have clear bounds so we're defining the map's limits here.
@export var map_size = Vector2(9,8)
# You can only create an AStar3D node from code, not from the Scene tab.
@onready var _astar = BoardAstar.new()
# get_used_cells is a method from the TileMap node.
# Here the id 0 corresponds to the grey tile, the obstacles.
@onready var obstacles: Array[Vector2i]  = get_used_cells(1)

@onready var start_tile = [1, Vector2i(7, 11), 0]
@onready var end_tile = [1, Vector2i(8, 7), 0]

@onready var cell_to_atom = {}


var map_start: Vector2 = Vector2() :
	set(value):
		set_cell(PATH_LAYER, Vector2i(map_start), -1,Vector2i(-1, -1), -1)
		set_cell(PATH_LAYER, value, start_tile[0], start_tile[1], start_tile[2])
		map_start = value
		
			
var map_end: Vector2i = Vector2i() :
	set(value):
		if not _astar.is_in_boundsv(value):
			return 
		if value in obstacles:
			return

		set_cell(PATH_LAYER, map_start, -1, Vector2i(-1, -1), -1)
		set_cell(PATH_LAYER, value, end_tile[0], end_tile[1], end_tile[2])
		map_end = value

var _map_path: PackedVector2Array = []

func _ready():
	_init_astar(obstacles)


func _draw():
	if _map_path.is_empty():
		return
	var id_start = _map_path[0]
	var id_end = _map_path[_map_path.size() - 1]

	set_cell(PATH_LAYER, id_start, start_tile[0], start_tile[1], start_tile[2])
	set_cell(PATH_LAYER, id_end, end_tile[0], end_tile[1], end_tile[2])

	var last_point = map_to_local_float(id_start) 
	for index in range(1, _map_path.size()):
		var now_point = map_to_local_float(_map_path[index])
		draw_line(last_point, now_point, DRAW_COLOR, BASE_LINE_WIDTH)
		draw_circle(now_point, BASE_LINE_WIDTH * 2.0, DRAW_COLOR)
		last_point = now_point


func _init_astar(obstacle_list: Array = []):
	_astar.set_default_heuristic(AStarGrid2D.HEURISTIC_MANHATTAN)
	_astar.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_NEVER)
	_astar.size = map_size
	_astar.cell_size = tile_set.tile_size
	_astar.update()
	for point_map in obstacle_list:
		_astar.set_point_solid(point_map)


func clear_previous_path_drawing():
#	print(_map_path.is_empty())
	if _map_path.is_empty():
		return
	var path_start = _map_path[0]
	var path_end = _map_path[len(_map_path) - 1]
#	print("prev path", path_start, path_end)
	set_cell(PATH_LAYER, path_start, -1, Vector2i(-1, -1), -1)
	set_cell(PATH_LAYER, path_end, -1, Vector2i(-1, -1), -1)


func get_astar_path(local_start, local_end) -> Array[Vector2]:
	map_start = local_to_map_float(local_start)	
	map_end = local_to_map(local_end)
#	print("start", local_start, map_start, local_to_map(local_start))
#	prints("map start and end", map_start, map_end)
	_recalculate_path()
#	print("map path", _map_path)
	var local_path = []
	for point in _map_path:
		var point_world = map_to_local_float(point) 
		local_path.append(point_world)

#	print(local_path)
	return local_path


func _recalculate_path() -> void:
	clear_previous_path_drawing()
	# This method gives us an array of points. Note you need the start and
	# end points' indices as input.
#	prints("map start and end", map_start, map_end)

	for point_map in cell_to_atom.keys():
		if point_map != map_end:
			_astar.set_point_solid(point_map, true)
	_map_path = _astar.get_id_path_float(map_start, map_end)
	for point_map in cell_to_atom.keys():
		if point_map != map_end:
			_astar.set_point_solid(point_map, false)

	# Redraw the lines and circles from the start to the end point.
	queue_redraw()


func insert_cell_to_atom(cell, atom):
	if cell in cell_to_atom.keys():
		assert(atom == cell_to_atom[cell])
	else:
		cell_to_atom[cell] = atom
	

func local_to_map_float(p) -> Vector2:
	return Vector2(p.x/tile_set.tile_size.x, p.y/tile_set.tile_size.y) - \
		Vector2.ONE /2. 

func map_to_local_float(p) -> Vector2:
	return Vector2((p.x + 0.5) * tile_set.tile_size.x, (p.y +0.5)* tile_set.tile_size.y)


func get_cells_within_range(o:Vector2i, r:int, type: String ="manhattan") -> Array[Vector2i]:
	var res = []
	match type:
		"manhattan":
			var x_shift 
			var y_shift
			var p: Vector2i
			for i in range(2 * r + 1):
				x_shift = i - r
				for j in range(2 * (r - abs(x_shift)) + 1 ):
					y_shift = j - (r - abs(x_shift))
#					print(x_shift, " ", y_shift)
					p = o + Vector2i(x_shift, y_shift)
					if _astar.is_in_boundsv(p):
						res.append(o + Vector2i(x_shift, y_shift))
		_:
			printerr("unsupported type ", type)
	return res


func get_atoms_within_range(o:Vector2i, r:int, type: String ="manhattan"):
	var res = []
	var atom
	for cell in get_cells_within_range(o, r, type):
		atom = cell_to_atom.get(cell)
		if atom:
			res.append(atom)
	return res
