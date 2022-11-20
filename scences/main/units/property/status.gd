extends Node
var data =  BoardPropertyManager.new()



#status.insert_base("life", 100)
@export var population_max = 1000
@export var life_max_per_population = 1200




	
@export var morale_max = 2000
@export var morale_init = 1000
@export var tactic_max = 100
@export var tactic_init = 0





func _init():
	data.insert("population_max", population_max) # 最大士兵数
	var population_init = func():
		return data.get_final_var("population_max")	
	data.insert("population_init", population_init, 0, data.implicit_get("final_var","population_max")) # 初始士兵数
	data.insert("population", data.get_final_var("population_init"), 0, data.implicit_get("final_var","population_max")) # 士兵数
	var population_percentage=func():
		return data.get_final_var("population") * 100 /data.get_final_var("population_max")
	data.insert("population_percentage", population_percentage)
	
	data.insert("life_max_per_population", life_max_per_population)
	var life_max = func():
		return data.get_final_var("population_max") * data.get_final_var("life_max_per_population")
	data.insert("life_max", life_max) # 最大生命
	var life_init = func():
		return data.get_final_var("life_max")
	data.insert("life_init", life_init, 0, data.implicit_get("final_var","life_max")) # 生命/士兵数
	var life_recovery_max = func():
		return data.get_final_var("population_max") * data.get_final_var("life_max_per_population")
	data.insert("life_recovery_max", life_recovery_max, 0, data.implicit_get("final_var","life_max"))	
	data.insert("life",data.get_final_var("life_init"), 0, data.implicit_get("final_var","life_recovery_max"))
	var life_injured=func():
		return data.get_final_var("life_recover_max") - data.get_final_var("life")
	data.insert("life_injured", life_injured)
	var life_percentage=func():
		return data.get_final_var("life") * 100 /data.get_final_var("life_max")
	data.insert("life_percentage", life_percentage)
	
	data.insert("morale_max", morale_max) #士气
	data.insert("morale_init", morale_init, 0, data.implicit_get("final_var","morale_max")) #士气
	data.insert("morale", data.get_final_var("morale_init"), 0, data.implicit_get("final_var","morale_max")) #士气
	var morale_percentage=func():
		return data.get_final_var("morale") * 100 /data.get_final_var("morale_max")
	data.insert("morale_percentage", morale_percentage)
	
	data.insert("tactic_max", tactic_max) #士气
	data.insert("tactic_init", tactic_init, 0, data.implicit_get("final_var","tactic_max")) #士气
	data.insert("tactic", data.get_final_var("tactic_init"), 0, data.implicit_get("final_var","tactic_max")) #士气
	var tactic_percentage=func():
		return data.get_final_var("tactic") * 100 /data.get_final_var("tactic_max")
	data.insert("tactic_percentage", tactic_percentage)
#	print_debug("get life", life, data.get_final("life"), data.get_base("life"), data.get("life"))
#	print_debug("get morale", morale, data.get_final("morale"),data.get_base("morale"), data.get("morale"))
#	print_debug("get tactic", tactic, data.get_final("tactic"),data.get_base("tactic"), data.get("tactic"))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
