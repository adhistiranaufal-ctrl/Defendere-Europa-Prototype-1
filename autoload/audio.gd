extends Node

@onready var sfx_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var chatter_player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(sfx_player)
	add_child(chatter_player)

func play_sfx(stream: AudioStream):
	if stream:
		sfx_player.stream = stream
		sfx_player.play()

func play_chatter(stream: AudioStream):
	if stream and not chatter_player.playing:
		chatter_player.stream = stream
		chatter_player.play()
