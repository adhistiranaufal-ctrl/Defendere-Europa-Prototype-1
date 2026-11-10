extends Node

signal credits_changed(new_amount: int)
signal lives_changed(new_amount: int)
signal wave_started(wave_number: int)
signal game_over
signal game_won

var credits: int = 500:
	set(value):
		credits = value
		credits_changed.emit(credits)

var lives: int = 20:
	set(value):
		lives = maxi(value, 0)
		lives_changed.emit(lives)
		if lives == 0 and not finished:
			finished = true
			game_over.emit()

var current_wave: int = 0
var total_waves: int = 0
var finished := false

func start_wave(n: int) -> void:
	current_wave = n
	wave_started.emit(n)

func win() -> void:
	if finished:
		return
	finished = true
	game_won.emit()

func reset() -> void:
	finished = false
	credits = 500
	lives = 20
	current_wave = 0
