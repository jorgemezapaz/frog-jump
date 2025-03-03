class_name StateMachine extends Node

@onready var controlled_node = self.owner
@export var default_state: StateBase

var currennt_state: StateBase = null
func _ready() -> void:
	call_deferred("_state_default_start")

func _state_default_start()->void:
	currennt_state = default_state
	_state_start()

func _state_start(params: Dictionary = {}) -> void:
	prints("StateMachine", controlled_node.name, "start state", currennt_state.name)
	
	currennt_state.controlled_node = controlled_node
	currennt_state.state_machine = self
	currennt_state.start(params)
	
func change_state(new_state: String, params: Dictionary = {})->void:
	if currennt_state and currennt_state.has_method("exit"): 
		currennt_state.exit()
	currennt_state = get_node(new_state)
	_state_start(params)

#region metodos que se ejecutan solos

func _process(delta: float) -> void:
	if currennt_state and currennt_state.has_method("on_process"):
		currennt_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if currennt_state and currennt_state.has_method("on_physics_process"):
		currennt_state.on_physics_process(delta)

func _input(event: InputEvent) -> void:
	if currennt_state and currennt_state.has_method("on_input"):
		currennt_state.on_input(event)

#endregion
