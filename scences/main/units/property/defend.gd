extends Node
var data = BoardPropertyManager.new()

@export var armor = 0
@export var reduction = 0


func _init():
	data.insert("armor", armor)
	data.insert("reduction", reduction)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
