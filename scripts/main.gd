extends Node2D

const ENEMY_SCENE = preload("res://scenes/enemy.tscn")

@export var waves: Array[WaveData] = []
@export var first_wave_delay := 3.0

@onready var zombie_path: Path2D = $Zombiepath

var alive := 0

func _ready() -> void:
	Game.reset()
	Game.total_waves = waves.size()
	_run_waves()

func _run_waves() -> void:
	await get_tree().create_timer(first_wave_delay).timeout
	for i in waves.size():
		if Game.finished:
			return
		var w := waves[i]
		Game.start_wave(i + 1)

		for n in w.count:
			if Game.finished:
				return
			_spawn(w.enemy_data)
			await get_tree().create_timer(w.spawn_gap).timeout

		# wait until every enemy of this wave is dead or escaped
		while alive > 0 and not Game.finished:
			await get_tree().process_frame

		if i < waves.size() - 1:
			await get_tree().create_timer(w.pause_after).timeout

	Game.win()

func _spawn(data: EnemyData) -> void:
	var e: Enemy = ENEMY_SCENE.instantiate()
	e.data = data  # before add_child
	alive += 1
	e.died.connect(_on_enemy_gone)
	e.escaped.connect(_on_enemy_gone)
	zombie_path.add_child(e)

func _on_enemy_gone() -> void:
	alive -= 1
