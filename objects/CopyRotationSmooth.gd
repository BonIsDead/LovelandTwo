class_name CopyRotationSmooth extends Node3D

@export var targetPath:NodePath
var target:Node

@export var speed:float = 12.0

func _ready() -> void:
	target = get_node_or_null(targetPath)
	if (target == null):
		printerr("No target path specified!")
		queue_free()

func _process(delta:float) -> void:
	var _a = target.basis
	var _b = transform.basis
	var _c = _b.slerp(_a, speed * delta)
	transform.basis = _c.orthonormalized()
