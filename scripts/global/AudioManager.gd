extends Node

const MAX_AUDIO_PLAYERS = 5
var audio_players: Array = []

func _ready() -> void:
	for i in range(MAX_AUDIO_PLAYERS):
		var player = AudioStreamPlayer2D.new()
		player.bus = "sfx"
		add_child(player)
		audio_players.append(player)

func play_sfx(sfx_sound: AudioStream):
	for player in audio_players:
		if not player.playing:
			player.stream = sfx_sound
			player.play()
			return
	var new_player = AudioStreamPlayer2D.new()
	new_player.bus = "sfx"
	add_child(new_player)
	audio_players.append(new_player)
	new_player.stream = sfx_sound
	new_player.play()
