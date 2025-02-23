extends CanvasLayer

@onready var jump_label: Label = $VBoxContainer/HBoxContainer/jump_count
@onready var fell_label: Label = $VBoxContainer/VBoxContainer/fell_count

@export var jump_count: int = 0
@export var fell_count: int = 0

func _ready() -> void:
	GlobalSignal.player_jump.connect(add_jump)
	GlobalSignal.player_fell.connect(add_fell)

func _process(delta: float) -> void:
	jump_label.text = str(jump_count)
	fell_label.text = str(fell_count)

func add_jump():
	jump_count+=1

func add_fell():
	fell_count+=1
