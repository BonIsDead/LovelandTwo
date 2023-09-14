class_name Player extends CharacterBody3D

## How quickly the player reaches max speed
const ACCELERATION:float = 32.0
## How quickly the player slows down
const DECELERATION:float = 48.0
## How fast the player walks
const WALK_SPEED:float = 4.0
## How fast the player runs
const RUN_SPEED:float = 8.0
## The velocity of the players jump
const JUMP_VELOCITY:float = 5.0
## Percentage loss/gained while airborne
const AIR_DRAG:float = 0.4

## Gravity from the project default
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

## Input for movement
var moveVector:Vector2
## If the jump button was pressed
var jumpPressed:bool
## If the run button is being held down
var runHeld:bool

func _process(delta:float) -> void:
	# Movement input
	moveVector = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_backward")
	
	# Jump input
	if Input.is_action_just_pressed("jump"): jumpPressed = true
	# Run input
	runHeld = Input.is_action_pressed("run")

func _physics_process(delta:float) -> void:
	# Gets the current cameras forward direction
	var _cameraForwardAngle:float = get_viewport().get_camera_3d().global_transform.basis.get_euler().y
	# Aligned the "moveVector" to the camera forward direction
	var _direction:Vector3 = Vector3(moveVector.x, 0, moveVector.y).rotated(Vector3.UP, _cameraForwardAngle)
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Jumping
	if (jumpPressed) and (is_on_floor() ):
		velocity.y = JUMP_VELOCITY
		jumpPressed = false
	
	# Get speed based on input
	var _speed:float = WALK_SPEED if (not runHeld) else RUN_SPEED
	
	# Get acceleration speed based on movement direction
	var _isAccelerating:bool = (_direction.dot(velocity) > 0.0)
	var _accel:float = ACCELERATION if _isAccelerating else DECELERATION
	if not is_on_floor(): _accel *= AIR_DRAG
	
	# Smoothly interpolated velocity to the goal velocity
	var _goalVelocity:Vector3 = (_direction * _speed)
	velocity = velocity.move_toward(Vector3(_goalVelocity.x, velocity.y, _goalVelocity.z), _accel * delta)
	
	# Update the CharacterBody3D
	move_and_slide()
