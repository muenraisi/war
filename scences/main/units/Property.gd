extends Node

var data =  BoardPropertyManager.new()

@export var speed = 200
@onready var status = $status.data
@onready var attack = $attack.data
@onready var tactic = $tactic.data
@onready var defend = $defend.data
@onready var morale = $morale.data


var modifies = []



func get_value(val_name: StringName):
	if data.has(val_name):
		return data.get_final_var(val_name)
	else:
		match val_name:
			"x":
				pass
			_:
				pass
	return


# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

