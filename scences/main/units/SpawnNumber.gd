class_name SpawnNumber
extends Node2D

@onready var label:Label = $LabelContainer/Label
@onready var label_container:Node2D = $LabelContainer
@onready var ap:AnimationPlayer = $AnimationPlayer

var label_settings_damage:LabelSettings = preload("res://scences/main/units/spawn_number/label_settings_damage.tres")
var label_settings_morale:LabelSettings = preload("res://scences/main/units/spawn_number/label_settings_morale.tres")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_number_and_animate(number:float, start_pos:Vector2, height:float, spread:float, id:int, label_settings_name:String) -> void:
	label.text = str(round(number))
	match label_settings_name:
		"damage":
			label.set_label_settings(label_settings_damage)
		"morale":
			label.set_label_settings(label_settings_morale)
		_:
			push_warning("unknwon label settings type")
#	print_debug(label.label_settings, label.label_settings.get_instance_id(),label.label_settings.font_color)
	ap.play("Rise and Fade")
	
	var tween = get_tree().create_tween()
	seed(id)
	var end_pos = Vector2(randf_range(-spread,spread),-height) + start_pos
	var tween_length = ap.get_animation("Rise and Fade").length
	
	tween.tween_property(label_container,"position",end_pos,tween_length).from(start_pos)


func remove() -> void:
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
