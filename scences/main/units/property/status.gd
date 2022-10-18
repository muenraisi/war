extends BoardProperty



#status.insert_base("life", 100)


@export var life = 100
@export var morale = 50
@export var tactic = 0

func _init():
	insert_base("life", life)
	insert_base("morale", morale)
	insert_base("tatic", tactic)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
