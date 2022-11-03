extends Node
var data = BoardPropertyManager.new()

@export var life_morale_ratio = 10. # if lost 10% life, lose 100% morale


func _init():
	data.insert("life_morale_ratio", life_morale_ratio)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
