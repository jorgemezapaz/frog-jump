extends Node2D

@export var value: float = 0.0
@export var show: bool = false

@onready var sprite : Sprite2D = $Sprite2D

func _physics_process(delta: float) -> void:

	visible = show
	
	if value < 91:
		# Cada 7 valores, cambia de frame
		sprite.frame = int(value / 7)
	else:
		# Si el valor es 91 o mayor, asigna el frame 14
		sprite.frame = 14

func update_value(current_value:float)->void:
	value = current_value

func show_bar(show_bar: bool)->void:
	show = show_bar
