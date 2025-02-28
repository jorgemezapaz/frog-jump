class_name DynamicCamera2D extends Camera2D

@onready var trigger: Area2D = $Trigger
@onready var shape: CollisionShape2D = $Trigger/shape
var tween: Tween

func _on_trigger_area_entered(area: Area2D) -> void:
	var zone = area.get_node_or_null("Zone")
	if zone and zone.shape is RectangleShape2D:
		var size = zone.shape.extents * 2  # Usamos extents para obtener el tamaño real
		var position_center = area.global_position
		# Solo actualizar la posición Y, manteniendo la X
		var new_position = Vector2(position.x, position_center.y)
		# Limitar la cámara en la zona
		limit_bottom = position_center.y + size.y / 2
		limit_top = position_center.y - size.y / 2
		limit_right = area.global_position.x + size.x/2
		limit_left = area.global_position.x - size.x/2
		# Mover la cámara a la nueva zona con suavizado
		move_camera_to(new_position)

func move_camera_to(target_position: Vector2) -> void:
	# Si hay un Tween en ejecución, lo eliminamos antes de crear uno nuevo
	# Creamos un nuevo Tween
	tween = create_tween()
	
	if tween and tween.is_running():
		tween.kill()

	if tween:
		# Fijamos la posición en Y, manteniendo la X actual
		var new_position = Vector2(target_position.x, target_position.y)
		tween.tween_property(self, "position", new_position, 0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		position.y = target_position.y  # Solo cambiamos Y manualmente
