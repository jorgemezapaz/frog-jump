class_name Idle extends GravityStateBase

func on_physics_process(delta: float) -> void:
	if player.direction == FRONT:
		set_sprite(player_animation_name.Idle)
	else:
		set_sprite(player_animation_name.IdleSide)
		
	apply_gravity(delta)
	player.move_and_slide()
		
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and player.is_on_floor():
		state_machine.change_state(player_state_name.ChargingJump)
	
	if event.is_action_pressed("right"):
		player.direction = RIGHT
	elif event.is_action_pressed("left"):
		player.direction = LEFT
	elif event.is_action_pressed("up"):
		player.direction = FRONT
