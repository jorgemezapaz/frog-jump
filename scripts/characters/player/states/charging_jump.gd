class_name ChargingJump extends GravityStateBase

var charge_speed: float = 5.0  # Velocidad con la que se llena la barra de carga
var charge_force: float = 0.0

func start(params = {}):
	charge_force = 0.0
	player.velocity.x = 0 

func on_physics_process(delta: float) -> void:
	if Input.is_action_pressed("jump") and player.is_on_floor():
		# Aumentar carga hasta el límite de 1.0
		charge_force += charge_speed * (delta / 7)
		charge_force = min(charge_force, 1.0)

	elif Input.is_action_just_released("jump"):
		state_machine.change_state(player_state_name.Jumping, { "charge_force": charge_force })
		
	if player.direction == FRONT:
		set_sprite(player_animation_name.ChargingJumpFront)
	else:
		set_sprite(player_animation_name.ChargingJumpSide)	
	
	apply_gravity(delta)
	player.move_and_slide()
	
func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("right"):
		player.direction = RIGHT
	elif event.is_action_pressed("left"):
		player.direction = LEFT
	elif event.is_action_pressed("up"):
		player.direction = FRONT
