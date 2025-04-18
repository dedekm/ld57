extends Node3D

@export var description : Array[String]

func interact() -> void:
	print("Interacted with:", name)
	
	if description:
		var ui = get_tree().get_current_scene().user_interface
		ui.add_text_lines(description)
		ui.read_next_text_line()
