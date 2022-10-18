extends Menu

@onready var save_button = $Panel/Column/SaveButton
@onready var load_button = $Panel/Column/LoadButton

func open(args={}):
	super.open()
	save_button.grab_focus()
