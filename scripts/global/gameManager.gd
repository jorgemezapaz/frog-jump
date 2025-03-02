extends Node

var total_time: int = 0  # Tiempo total jugado (en segundos)
var session_time: int = 0  # Tiempo de la partida actual (en segundos)

@onready var timer: Timer = $session_time_timer
@onready var world: Node2D = $"../world"

func _ready() -> void:
	#load_total_time()  # Cargar el tiempo total guardado
	timer.start(1)  # Inicia el Timer para contar cada segundo
	var config = ConfigFile.new()
	load_data(config)

func save_data(config:ConfigFile ):
	config.set_value("game", "total_time", 0)  # Guardamos un valor inicial
	config.save("user://data.cfg")  # Guarda en la carpeta de usuario

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		print("reload")
		reload_level()

func _on_session_time_timer_timeout() -> void:
	total_time += 1
	session_time += 1
	print("Tiempo total: ", format_time(total_time), " | Partida actual: ", format_time(session_time))

func format_time(seconds: int) -> String:
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var secs = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, secs]

func load_data(config: ConfigFile):
		# Load data from a file.
	var err = config.load("user://data.cfg")
	# If the file didn't load, ignore it.
	if err != OK:
		print("El archivo no existe, creando uno nuevo...")
		save_data(config) # Si no existe, lo creamos
	else:
		print("Archivo cargado exitosamente.")
		total_time = config.get_value("game", "total_time", 0)
		print("Tiempo total cargado:", total_time)

func reset_session_time() -> void:
	session_time = 0  # Reiniciar tiempo de la partida
	
func reload_level():
	#TODO: mejorar, agregar alguna transicion o algo porque actualmente se ve feo
	var current_scene = get_node("/root/Game/world")  # Accede al nodo "world" dentro de "Game"
	if current_scene:
		for child in current_scene.get_children():
			if child is Node2D:
				child.queue_free()
	
	await get_tree().process_frame
	var new_world = preload("res://scenes/world/world.tscn").instantiate()
	current_scene.add_child(new_world)
	new_world.owner = current_scene
	
