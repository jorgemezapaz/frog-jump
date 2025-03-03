class_name StateBase extends Node

var controlled_node: Node
var state_machine: StateMachine

func start(params: Dictionary = {})->void:
	pass

func exit()->void:
	pass

func on_process(delta:float)->void:
	pass

func on_physics_process(delta:float)->void:
	pass

func on_input(event: InputEvent):
	pass
