extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	print_debug(owner.property.get_node("status").get_percentage("morale"))
	value = owner.property.get_node("status").get_percentage("morale")
