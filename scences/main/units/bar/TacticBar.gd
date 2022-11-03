extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = owner.property.get_node("status").get_percentage("tactic")
