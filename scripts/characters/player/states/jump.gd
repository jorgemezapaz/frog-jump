class_name Jump extends GravityStateBase

var jump_force: float = 500  # Fuerza máxima de salto
var max_horizontal_force: float = 300  # Máxima fuerza horizontal
var min_horizontal_force: float = 50  # Fuerza horizontal mínima (para saltos cortos)
var charge_force: float = 0.0  # Carga de salto recibida

func start(params = {}):
	charge_force = params.get("charge_force", 0.0) 
	
	var jump_strength = lerp(200.0, jump_force, charge_force)
	var horizontal_force = lerp(min_horizontal_force, max_horizontal_force, charge_force)
	# emitimos señal para el contador de saltos
	GlobalSignal.player_jump.emit()
	# aplicamos fuerza al salto
	prints("charge_force:", charge_force, "direction",player.direction)
	player.velocity.y = -jump_strength
	player.velocity.x = horizontal_force * player.direction
	player.last_charge_timer = charge_force
	# Reproducir sonido
	player.play_sfx("jump")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_physics_process(delta:float):
	if player.direction == FRONT:
		set_sprite(player_animation_name.JumpFront)
	else:
		set_sprite(player_animation_name.JumpSide)
		
	if player.velocity.y > 0:
		state_machine.change_state(player_state_name.Idle)
	
	apply_gravity(delta)
	player.move_and_slide()

	
