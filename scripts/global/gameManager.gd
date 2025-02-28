extends Node

var total_time: int = 0  # Tiempo total jugado (en segundos)
var session_time: int = 0  # Tiempo de la partida actual (en segundos)

@onready var timer: Timer = $session_time_timer

func _ready() -> void:
	#load_total_time()  # Cargar el tiempo total guardado
	timer.start(1)  # Inicia el Timer para contar cada segundo
	var config = ConfigFile.new()
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

func save_data(config:ConfigFile ):
	config.set_value("game", "total_time", 0)  # Guardamos un valor inicial
	config.save("user://data.cfg")  # Guarda en la carpeta de usuario
	print("Datos guardados en:", ProjectSettings.globalize_path("user://data.cfg"))

func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
	#print("Tiempo total: ", format_time(total_time), " | Partida actual: ", format_time(session_time))

func _on_session_time_timer_timeout() -> void:
	total_time += 1
	session_time += 1
	print("Tiempo total: ", format_time(total_time), " | Partida actual: ", format_time(session_time))

func format_time(seconds: int) -> String:
	var hours = seconds / 3600
	var minutes = (seconds % 3600) / 60
	var secs = seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, secs]
	
