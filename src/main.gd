extends Node3D

@onready var player = $Player
@onready var camera = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var from = camera.project_ray_origin(event.position)
		var to = from + camera.project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.exclude = [player]
		var result = space_state.intersect_ray(query)

		if result:
			var point = result.position
			print(point)
			player.agent.set_target_position(point)
