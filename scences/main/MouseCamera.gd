extends Camera2D

@export var pan_scale = 30
@export var zoom_scale = 1.2

var fixed_toggle_point = Vector2(0,0)
var dragging = false

#func _init():
#	print("zoom: ", zoom)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom *= zoom_scale
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom /= zoom_scale
			
			
func _process(_delta):
		if Input.is_action_just_pressed("middle_click"):
			print_debug("just pressed middle")
			fixed_toggle_point = get_viewport().get_mouse_position()
		elif Input.is_action_pressed("middle_click"):
			print_debug("pressed middle")
			var ref = get_viewport().get_mouse_position()
			position.x += (ref.x - fixed_toggle_point.x) / pan_scale
			position.y += (ref.y - fixed_toggle_point.y)  / pan_scale
		elif Input.is_action_pressed("right"):
			position.x += 100. / pan_scale
		elif Input.is_action_pressed("left"):
			position.x -= 100. / pan_scale
		elif Input.is_action_pressed("up"):
			position.y -= 100. / pan_scale
		elif Input.is_action_pressed("down"):
			position.y += 100. / pan_scale

