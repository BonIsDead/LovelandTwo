## A node designed to handle a first-person camera rig
class_name FirstPersonCamera extends Camera3D

## Horizontal sensitivity
var sensitivityX:float
## Vertical sensitivity
var sensitivityY:float
## If the y-axis is reversed
var reversed:bool

## Enable camera smoothing
var smoothingEnabled:bool
## Smoothing value
var smoothing:float

## If the controller is enabled
var controllerEnabled:bool

## Input vector from the mouse/controller
var inputVector:Vector2

func _ready() -> void:
	# Capture mouse input
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Link "configChanged" signal to syncing method
	GameManager.configChanged.connect(configSync)
	configSync()

func _unhandled_input(event:InputEvent) -> void:
	# Update mouse input
	if (event is InputEventMouseMotion) and (not controllerEnabled):
		inputVector -= event.relative * Vector2(sensitivityX, sensitivityY)
	
	# Update controller input
	if (event is InputEventJoypadMotion) and (controllerEnabled):
		pass

func _process(delta:float) -> void:
	# Skip process if the mouse input isn't captured
	if (not Input.mouse_mode == Input.MOUSE_MODE_CAPTURED): return
	
	# Limit/wrap inputs
	inputVector.x = wrapf(inputVector.x, -180.0, 180.0)
	inputVector.y = clampf(inputVector.y, -90.0, 90.0)
	
	# Update the camera rotation
	var _yaw:float = deg_to_rad(inputVector.x)
	var _pitch:float = -deg_to_rad(inputVector.y) if reversed else deg_to_rad(inputVector.y)
	rotation.x = lerp_angle(rotation.x, _pitch, smoothing * delta) if smoothingEnabled else _pitch
	rotation.y = lerp_angle(rotation.y, _yaw, smoothing * delta) if smoothingEnabled else _yaw
	

## Called whenever the config file is changed
func configSync() -> void:
	# Change input type (purely for shorter code)
	var _inputType:String = "mouse"
	if (GameManager.config.get_value("controller", "enabled") ): _inputType = "controller"
	
	sensitivityX = GameManager.config.get_value(_inputType, "sensitivity_x")
	sensitivityY = GameManager.config.get_value(_inputType, "sensitivity_y")
	reversed = GameManager.config.get_value(_inputType, "reversed")
	
	smoothingEnabled = GameManager.config.get_value("camera", "smoothing_enabled")
	smoothing = GameManager.config.get_value("camera", "smoothing")
	fov = GameManager.config.get_value("camera", "fov")
	
	controllerEnabled = GameManager.config.get_value("controller", "enabled")
