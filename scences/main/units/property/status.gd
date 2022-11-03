extends Node
var data =  BoardPropertyManager.new()



#status.insert_base("life", 100)
@export var life_max = 1000
@export var life = 1000
@export var morale_max = 200
@export var morale = 100
@export var tactic_max = 100
@export var tactic = 0

func get_percentage(var_name):
#	if var_name=="morale":
#		print_debug(data.get_final_var(var_name), data.get_final_max(var_name), data.get_final_var(var_name) / data.get_final_max(var_name) * 100)
	return 100. * data.get_final_var(var_name) / data.get_final_max(var_name) 


func _init():
	data.insert("life", life, 0, life_max) # 生命/士兵数
	data.insert("morale", morale, 0, morale_max) #士气
	data.insert("tactic", tactic, 0, tactic_max) #战术
#	print_debug("get life", life, data.get_final("life"), data.get_base("life"), data.get("life"))
#	print_debug("get morale", morale, data.get_final("morale"),data.get_base("morale"), data.get("morale"))
#	print_debug("get tactic", tactic, data.get_final("tactic"),data.get_base("tactic"), data.get("tactic"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
