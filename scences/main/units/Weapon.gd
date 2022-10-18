extends Node2D

signal attack_finished

@export var attack_time = 1
@export var attack_power = 10
@export var attack_range = 1




func attack():
	print("attack")
	$AnimationPlayer.play("attack")
	await $AnimationPlayer.animation_finished
#	await get_tree().create_timer(attack_time).timeout
	emit_signal("attack_finished")

