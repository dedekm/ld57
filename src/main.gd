extends Node3D

@onready var player = $Player
@onready var camera = $Camera3D
@onready var user_interface = $UserInterface

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if user_interface.active:
			user_interface.read_next_text_line()
		else:
			var from = camera.project_ray_origin(event.position)
			var to = from + camera.project_ray_normal(event.position) * 1000

			var space_state = get_world_3d().direct_space_state
			var query = PhysicsRayQueryParameters3D.create(from, to)
			query.exclude = [player]
			query.collide_with_areas = true
			var result = space_state.intersect_ray(query)

			if result:
				var target = result.position
				var collider = result.collider.get_parent()

				if collider.has_method("interact"):
					player.move_to_target(target, collider)
				else:
					player.move_to_target(target)
