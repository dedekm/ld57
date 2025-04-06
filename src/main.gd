extends Node3D

@onready var user_interface = $UserInterface
@onready var preloaded_stories = {
	"story_b" : preload("res://src/story_b.tscn")
}

var current_story : Node3D
var player : CharacterBody3D
var camera : Camera3D

func _ready() -> void:
	_set_current_story($StoryA)

func _set_current_story(story: Node3D) -> void:
	current_story = story

	player = current_story.get_node("Player")
	assert(player, "player is missing in current story")
	
	camera = current_story.get_node("Camera")
	assert(camera, "camera is missing in current story")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if user_interface.active:
			user_interface.read_next_text_line()
		else:
			_set_target_for_player(event)

func _set_target_for_player(event: InputEventMouseButton) -> void:
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

func _on_user_interface_tag_clicked(tag: Variant) -> void:
	print(tag + " tag clicked")
	user_interface.read_next_text_line()
	_start_new_story(tag)

func _start_new_story(story_name: String) -> void:
	var story_scene = preloaded_stories[story_name]
	var story = story_scene.instantiate()
	add_child(story)
	current_story.queue_free()
	_set_current_story(story)
