extends CharacterBody2D

@export var jump_force: float = 800  # Fuerza máxima de salto
@export var gravity: float = 1200  # Simula la gravedad
@export var charge_speed: float = 5.0  # Velocidad con la que se llena la barra de carga
@export var max_horizontal_force: float = 300  # Máxima fuerza horizontal
@export var min_horizontal_force: float = 50  # Fuerza horizontal mínima (para saltos cortos)
@export var wall_bounce_force: float = 200  # Fuerza del rebote contra paredes

@onready var charge_bar: Node2D = $charge_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $sfx
@onready var jump_sfx: AudioStream = preload("res://assets/sfx/jump.wav")
@onready var bounce_sfx: AudioStream = preload("res://assets/sfx/hitHurt.wav")


var charge_timer: float = 0.0
var last_charge_timer: float = 0.0
var is_charging: bool = false  # Si el jugador está cargando el salto
var direction: int = 0
const LEFT: int = -1
const RIGHT: int = 1
const FRONT: int = 0

# Variables para detectar caídas
var is_falling: bool = false
var fall_start_y: float = 0.0
var fall_distance_threshold: float = 300.0  # Distancia mínima para considerar una caída real


func _physics_process(delta: float) -> void:
	# Aplicar gravedad
	apply_gravity(delta)
	# Manejar dirección
	direction_handler()
	# Reducir velocidad en el suelo para evitar deslizamiento
	reduce_sliding_on_ground()
	# Manejar salto con carga
	jump_handler(delta)
	# Detectar colisiones para aplicar rebote en paredes
	bounce_handler()
	# Manejar animaciones
	animation_handler()
	
	# Detectar el inicio de una caída real
	if velocity.y > 0 and not is_on_floor() and not is_falling:
		is_falling = true
		fall_start_y = global_position.y  # Guardar la posición desde donde empieza a caer

	# Detectar si aterriza después de caer
	if is_on_floor() and is_falling:
		var fall_distance = global_position.y - fall_start_y
		print(fall_distance)
		if fall_distance > fall_distance_threshold:
			GlobalSignal.player_fell.emit()
		is_falling = false  # Reiniciar estado de caída
	
	move_and_slide()

func apply_gravity(delta:float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func reduce_sliding_on_ground() -> void:
	if is_on_floor() and !is_charging:
		velocity.x = lerp(float(velocity.x), 0.0, 0.1)

func direction_handler() -> void:
	if Input.is_action_pressed("right"):
		direction = RIGHT
	elif Input.is_action_pressed("left"):
		direction = LEFT
	elif Input.is_action_pressed("up"):
		direction = FRONT

func jump_handler(delta:float) -> void:
	if Input.is_action_pressed("jump") and is_on_floor():
		is_charging = true
		velocity.x = 0
		if charge_timer < 0.5:
			charge_timer+= charge_speed * (delta/10)
		else:
			charge_timer+= charge_speed * (delta/6)
		charge_timer = min(charge_timer, 1.0)
		if charge_timer == 1:
			charge_timer = 0
		# Actualizar la barra de carga del salto
		progress_bar_handler(true)
	elif Input.is_action_just_released("jump") and is_charging:
		var jump_strength = lerp(200.0, jump_force, charge_timer)
		var horizontal_force = lerp(min_horizontal_force, max_horizontal_force, charge_timer)
		
		GlobalSignal.player_jump.emit()
		
		play_sfx(jump_sfx)
		velocity.y = -jump_strength
		velocity.x = horizontal_force * direction
		last_charge_timer = charge_timer
		is_charging = false
		charge_timer = 0.0
		# Actualizar la barra de carga del salto
		progress_bar_handler(false)

func bounce_handler()->void:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		# Si colisiona con una pared (normal.x != 0) y está en el aire, aplica rebote
		if not is_on_floor() and abs(normal.x) > 0.8:
			play_sfx(bounce_sfx)
			velocity.x = (wall_bounce_force * last_charge_timer ) * sign(normal.x)  # Rebota en la dirección opuesta

func progress_bar_handler(is_visible: bool)->void:
	charge_bar.update_value(charge_timer * 100)
	charge_bar.show_bar(is_visible)

func animation_handler()->void:
	if is_on_floor():
		if FRONT == direction:
			animation_player.play("idle")
		elif RIGHT == direction:
			animation_player.play("idle_side")
			sprite.flip_h = true
		elif LEFT == direction:
			animation_player.play("idle_side")
			sprite.flip_h = false
	else:
		if FRONT == direction:
			if velocity.y < 0:
				animation_player.play("jump_start_front")
			else:
				animation_player.play("fall")
		elif RIGHT == direction:
			animation_player.play("jump_side")
		elif LEFT == direction:
			animation_player.play("jump_side")

func play_sfx(sfx_sound:AudioStream):
	sfx.stream = sfx_sound
	sfx.play()
