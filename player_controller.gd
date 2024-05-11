extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var friction = 6

@onready var head = $Head
@onready var camera = $Head/Camera
@onready var mouse_sensitivity = 0.5

var coins : int = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func coin_pouch():
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion:
		mouse_input(event)

func mouse_input(event):
	rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
	head.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("movement_left", "movement_right", "movement_up", "movement_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * friction * delta)
		velocity.z = move_toward(velocity.z, 0, SPEED * friction * delta)

	move_and_slide()
