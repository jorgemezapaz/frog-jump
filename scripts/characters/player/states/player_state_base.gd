class_name PlayerStateBase extends StateBase

const RIGHT: int = 1
const LEFT: int = -1
const FRONT: int = 0

var player_state_name: PlayerStateName = PlayerStateName.new()
var player_animation_name: PlayerAnimationName = PlayerAnimationName.new()


var player:Player:
	set(value):
		controlled_node = value
	get():
		return controlled_node

func set_sprite(sprite: String):
	if player.direction != FRONT:
		player.sprite.flip_h = (player.direction == RIGHT)
	player.animation_player.play(sprite)
