extends AnimatedSprite2D



func change_anim(anim_type:String):
	var face_direction = owner.face_direction
	if anim_type=="stand":
		if owner.face_direction == "up":
			animation = "stand_up"
			flip_h = false
		elif face_direction == "down":
			animation = "stand_down"
			flip_h = false
		else:
			animation = "stand_left"
			if face_direction == "right":
				flip_h = true
			else:
				flip_h = false
	elif anim_type=="walk":
		if owner.face_direction == "up":
			animation = "walk_up"
			flip_h = false
		elif face_direction == "down":
			animation = "walk_up"
			flip_h = false
		else:
			animation = "walk_up"
			if face_direction == "right":
				flip_h = true
			else:
				flip_h = false
	else:
		pass
	

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
