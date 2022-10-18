extends State


func receive_command(command_name: String, command_info: Dictionary = {}) -> void:
	match command_name:
		"stop":
			state_machine.transit_to("stop")
		"move":
			state_machine.transit_to(command_name, command_info)
		"attack":
			state_machine.transit_to(command_name, command_info)
