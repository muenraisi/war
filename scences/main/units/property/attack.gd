extends Node
var data = BoardPropertyManager.new()

# property for attack

@export var enable: bool = true
@export var damage: float = 10 # 攻击力
@export var r: int = 1


@export var foreswing: float = 0.6	# 攻击前摇 
@export var backswing: float = 0.4	# 攻击后摇
@export var idle: float = 0.1 # 攻击动画结束后时间


@export var projectile: float = 0 # projectile speed 如果为零，则表示无弹道
#@export var projectile_symbol
var animation = foreswing + backswing
var time: float = animation + idle
var speed: float = 100/ time	# 攻击速度

@export var target_type: String = "unit" # or unit or cell
@export_enum("manhattan","chebyshev","euclidean") var range_type 


func _init():
	data.insert("enable", enable)
	data.insert("damage", damage)
	data.insert("range", r)
	data.insert("speed", speed)
	data.insert("foreswing", foreswing)
	data.insert("backswing", backswing)
	data.insert("idle", idle)
	data.insert("projectile", projectile)
	data.insert("target_type", target_type)
	data.insert("range_type", range_type)

# Called when the node enters the scene tree for the first time.
func _ready():
#	print_debug("animaiton time ", animation)
#	print_debug("total time ", idle)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_atom_attack_finished():
	pass # Replace with function body.
