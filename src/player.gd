extends CharacterBody3D

@export var move_speed: float = 4.0

@onready var agent: NavigationAgent3D = $NavigationAgent3D

var target_object: Node3D = null

func _ready() -> void:
	agent.target_reached.connect(_on_target_reached)

func _physics_process(_delta: float) -> void:
	if !agent.is_navigation_finished():
		var next_position = agent.get_next_path_position()
		var target = next_position - global_position
		var distance = target.length()

		if distance > 0.1:
			var direction = target.normalized()
			velocity = direction * move_speed
			move_and_slide()

			var look_target = Vector3(next_position.x, global_position.y, next_position.z)
			look_at(look_target, Vector3.UP)
	else:
		velocity = Vector3.ZERO
		move_and_slide()

func move_to_target(target_position: Vector3, object: Node3D = null) -> void:
	agent.set_target_position(target_position)
	target_object = object

func _on_target_reached() -> void:
	print("Destination reached!")

	if target_object:
		target_object.interact()
		target_object = null
