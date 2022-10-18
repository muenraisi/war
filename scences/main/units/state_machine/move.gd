extends State

var target 

var path:Array


func enter(msg := {}) -> void:
	owner.destination = msg["destination"]
	target=msg["target"]


func physics_process(_delta):
	if target and target.position != owner.destination:
		owner.destination = target.position
	owner.move_destination()


func receive_command(command_name: String, command_info: Dictionary = {}) -> void:
	match command_name:
		"stop":
			state_machine.transit_to("stop")
		"move":
			enter(command_info)
		"attack":
			state_machine.transit_to("attack", command_info)
