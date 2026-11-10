extends CanvasLayer

@export var placement: Placement

@onready var credits_label: Label = %CreditsLabel
@onready var lives_label: Label = %LivesLabel
@onready var toolbar: HBoxContainer = %Toolbar
@onready var wave_label: Label = %WaveLabel
@onready var message_label: Label = %MessageLabel

var buttons: Array[Button] = []

func _ready() -> void:
	Game.credits_changed.connect(_on_credits)
	Game.lives_changed.connect(_on_lives)
	process_mode = Node.PROCESS_MODE_ALWAYS  # HUD keeps working while paused
	message_label.hide()
	wave_label.text = "Get ready..."
	Game.wave_started.connect(_on_wave)
	Game.game_over.connect(_on_game_over)
	Game.game_won.connect(_on_game_won)

	for i in placement.tower_types.size():
		var d := placement.tower_types[i]
		var b := Button.new()
		b.text = "%d: %s ($%d)" % [i + 1, d.unit_name, d.cost]
		b.icon = d.nato_symbol
		b.focus_mode = Control.FOCUS_NONE
		b.pressed.connect(placement.start_placing.bind(d))
		toolbar.add_child(b)
		buttons.append(b)

	_on_credits(Game.credits)
	_on_lives(Game.lives)


func _on_credits(amount: int) -> void:
	credits_label.text = "Credits: %d" % amount
	for i in buttons.size():
		buttons[i].disabled = placement.tower_types[i].cost > amount

func _on_lives(amount: int) -> void:
	lives_label.text = "Lives: %d" % amount

func _on_wave(n: int) -> void:
	wave_label.text = "Wave %d/%d" % [n, Game.total_waves]

func _on_game_over() -> void:
	message_label.text = "GAME OVER\nPress R to restart"
	message_label.show()
	get_tree().paused = true

func _on_game_won() -> void:
	message_label.text = "VICTORY!\nPress R to restart"
	message_label.show()
	get_tree().paused = true

func _unhandled_input(event: InputEvent) -> void:
	if Game.finished and event is InputEventKey and event.pressed and event.keycode == KEY_R:
		get_tree().paused = false
		get_tree().reload_current_scene()
