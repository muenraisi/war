extends Node2D

#func _ready():
#	print("position of atom is ", $atom.position)
#	print("position of solidier is ", $solider.position)
#	print("position of camera2d is ", $camera2d.position)


var dragging = false
var selected = []
var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()
var mouse_mode = "normal"

var normal_cursor = load("res://arts/cursor/arrow.png")
var attack_cursor = load("res://arts/cursor/aim_black.png")

func _ready():
	Common.debug_print("Debug mode is on")
	Input.set_custom_mouse_cursor(normal_cursor)
#	print(abs(Vector2(2,3)-Vector2(4,5)))


func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
				
#				print(drag_start, event.position, get_global_mouse_position(),get_viewport().get_mouse_position())
			else:
#				print("selected object becomes not controllable", selected)
				for item in selected:
					item.collider.controllable = false
				selected = []
				if mouse_mode != "normal":
					mouse_mode = "normal"
					Input.set_custom_mouse_cursor(normal_cursor)
		elif dragging:
			dragging  = false
			queue_redraw()
			var drag_end = get_global_mouse_position()
			select_rect.extents = abs(drag_end - drag_start) / 2
			var space = get_world_2d().direct_space_state
			var query = PhysicsShapeQueryParameters2D.new()
			query.set_shape(select_rect)
			query.transform = Transform2D(0, (drag_end + drag_start) /2)
			selected = space.intersect_shape(query)
#			print("selected object becomes controllable", selected)
#			if not selected and mouse_mode != "normal":
#				mouse_mode = "normal"
#				Input.set_custom_mouse_cursor(normal_cursor)
				
			for item in selected:
#				print(item.collider, item.collider.controllable)
				item.collider.controllable = true
#			print(selected)
	if event is InputEventMouseMotion and dragging:
		queue_redraw()
	if selected.size() !=0:
		if event.is_action_pressed("stop"):
			for item in selected:
				item.collider.receive_command("stop")
		elif event.is_action_pressed("right_click"):
			
			var mouse_pos = get_global_mouse_position()
			var mouse_point = PhysicsPointQueryParameters2D.new()
			mouse_point.position = mouse_pos
			# get the PhysicsDirectSpaceState2D object
			var space = get_world_2d().direct_space_state
			# Get the mouse's position
			# Check if there is a collision at the mouse position
			var intersect_object = space.intersect_point(mouse_point, 1)
			var target = null
			if intersect_object:
				target  = intersect_object[0].collider
		#		print("destination: ", destination)
			match mouse_mode:
				"normal":
					for item in selected:
						item.collider.receive_command("move", {"destination":mouse_pos, "target":target})
				"attack":
					for item in selected:
						item.collider.receive_command("attack", {"destination":mouse_pos, "target":target})
					mouse_mode = "normal"
					Input.set_custom_mouse_cursor(normal_cursor)
		elif event.is_action_pressed("attack"):
			Input.set_custom_mouse_cursor(attack_cursor)
			mouse_mode = "attack"
			
		
func _draw():
	if dragging:
#		print(drag_start, get_global_mouse_position(),get_viewport().get_mouse_position())
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start),
		Color(0.5, 0.5, 0.5), false)
