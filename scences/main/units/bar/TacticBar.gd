extends TextureProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	value = owner.property.status.get_final_var("tactic_percentage")
