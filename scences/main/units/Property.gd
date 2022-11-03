extends Node


@export var speed = 200
@onready var status = $status.data
@onready var attack = $attack.data
@onready var tactic = $tactic.data
@onready var defend = $defend.data


var modifies = []



# Called when the node enters the scene tree for the first time.
func _ready():

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

