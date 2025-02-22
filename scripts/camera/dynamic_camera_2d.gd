class_name DynamicCamera2D extends Camera2D

@onready var trigger: Area2D = $Trigger
@onready var shape: CollisionShape2D = $Trigger/shape

func _on_trigger_area_entered(area: Area2D) -> void:
	var zone = area.get_node_or_null("Zone")
	print(zone.name)
	if zone and zone.shape is RectangleShape2D:
		var size = zone.shape.size
		limit_bottom = area.global_position.y + size.y/2
		limit_top = area.global_position.y - size.y/2
		limit_right = area.global_position.x + size.x/2
		limit_left = area.global_position.x - size.x/2
