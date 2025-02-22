@tool
@icon("res://assets/icons/Camera2D.png")
class_name CameraZone2D extends Area2D

@onready var zone: CollisionShape2D = $Zone

@export var zone_dimentions: Vector2i = Vector2i(640, 360)

func _ready() -> void:
	resize_zone()

func resize_zone() -> void:
	if zone_dimentions:
		if zone.shape is RectangleShape2D:
			zone.shape.extents = zone_dimentions / 2
		else:
			printerr("Unsupported camera zone shape")
	else:
		printerr("Camera zone dimensions is null")
