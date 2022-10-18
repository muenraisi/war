extends Node

# property for attack

@export var enable: bool = true
@export var damage: float = 10 # 攻击力
@export var max_range: int = 1
@export var speed: float = 100	# 攻击速度
var time: float = 100 / speed
@export_range(0, 1) var foreswing_ratio: float = 0.6	# 攻击前摇 
@export_range(0, 1) var backswing_ratio: float = 0.4	# 攻击后摇
var idle_ratio = 1 - foreswing_ratio - backswing_ratio

@export_enum("single") var mode 
@export_enum("manhattan","chebyshev","euclidean") var range_type 


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(idle_ratio >= 0, "foreswing and backswing excess 1")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

