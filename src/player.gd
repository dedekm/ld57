extends CharacterBody3D

@onready var agent: NavigationAgent3D = $NavigationAgent3D
@export var move_speed: float = 4.0

func _ready():
	agent.target_reached.connect(_on_target_reached)

func _physics_process(delta):
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
	else:
		velocity = Vector3.ZERO
		move_and_slide()

func _on_target_reached():
	print("Destination reached!")
