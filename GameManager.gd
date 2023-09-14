extends Node

## The location of the config file
const CONFIG_PATH:String = "user://config.bon"
## The encryption passworld for the config file
const CONFIG_PASS:String = "WinnersDontDoDrugs"
## The config file for the games settings
var config:ConfigFile
## Emmitted whenever the config file is changed
signal configChanged

func _enter_tree() -> void:
	# Prevents this node from being paused
	set_process_mode(Node.PROCESS_MODE_ALWAYS)
	
	# Initialize the config file
	config = ConfigFile.new()
#	var _error:Error = config.load_encrypted_pass(CONFIG_PATH, CONFIG_PASS)
#	if (_error):
	config = configCreate()
	configSave()

## Returns an initialized ConfigFile
func configCreate() -> ConfigFile:
	var _config:ConfigFile = ConfigFile.new()
	# ---------- Mouse
	_config.set_value("mouse", "sensitivity_x", 0.2)
	_config.set_value("mouse", "sensitivity_y", 0.15)
	_config.set_value("mouse", "reversed", false)
	# ---------- Camera
	_config.set_value("camera", "smoothing_enabled", false)
	_config.set_value("camera", "smoothing", 16.0)
	_config.set_value("camera", "fov", 75.0)
	# ---------- Controller
	_config.set_value("controller", "enabled", false)
	_config.set_value("controller", "sensitivity_x", 0.2)
	_config.set_value("controller", "sensitivity_y", 0.15)
	_config.set_value("controller", "reversed", false)
	return _config

## Saves a config file to the "CONFIG_PATH" location
func configSave() -> void:
	config.save_encrypted_pass(CONFIG_PATH, CONFIG_PASS)
	configChanged.emit()
