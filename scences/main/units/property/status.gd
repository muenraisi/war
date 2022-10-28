extends Node
var data =  BoardPropertyManager.new()



#status.insert_base("life", 100)
@export var life_max = 100
@export var life = 100
@export var morale_max = 100
@export var morale = 50
@export var tactic_max = 100
@export var tactic = 0

func _init():
	data.insert("life", life, 0, life_max)
	data.insert("morale", morale, 0, morale_max)
	data.insert("tatic", tactic, 0, tactic_max)
#	print_debug("get life", life, data.get_final("life"), data.get_base("life"), data.get("life"))
#	print_debug("get morale", morale, data.get_final("morale"),data.get_base("morale"), data.get("morale"))
#	print_debug("get tactic", tactic, data.get_final("tactic"),data.get_base("tactic"), data.get("tactic"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
