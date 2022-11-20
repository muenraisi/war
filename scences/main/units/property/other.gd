extends Node
var data = BoardPropertyManager.new()

@export var damage_life_ratio = 100. # if lost 10% life, lose 100% morale

func _init():
	data.insert("damage_life_ratio", damage_life_ratio)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


