class_name GravityStateBase extends PlayerStateBase

@export var gravity: float = 1200  # Simula la gravedad

func apply_gravity(delta:float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity * delta
