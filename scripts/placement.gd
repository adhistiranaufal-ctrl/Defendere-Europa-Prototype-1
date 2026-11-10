extends Node2D
class_name Placement

const TOWER_SCENE = preload("res://scenes/tower.tscn")
const PATH_CLEARANCE := 40.0   # min distance from the enemy path
const TOWER_SPACING := 48.0    # min distance between towers

@export var path: Path2D                       # drag your Zombiepath here
@export var tower_types: Array[TowerData] = [] # drag your .tres files here

var ghost: Tower = null
var ghost_data: TowerData = null

func start_placing(data: TowerData) -> void:
	cancel()
	if Game.credits < data.cost:
		return
	ghost_data = data
	ghost = TOWER_SCENE.instantiate()
	ghost.data = data          # before add_child, same rule as enemies
	ghost.active = false
	ghost.show_range = true
	add_child(ghost)

func cancel() -> void:
	if ghost:
		ghost.queue_free()
	ghost = null
	ghost_data = null

func _process(_delta: float) -> void:
	if ghost == null:
		return
	var pos := get_global_mouse_position()
	ghost.global_position = pos
	var ok := _is_valid(pos) and Game.credits >= ghost_data.cost
	ghost.modulate = Color.WHITE if ok else Color(1, 0.4, 0.4, 0.7)

func _unhandled_input(event: InputEvent) -> void:
	# Hotkeys 1-9 select tower types
	if event is InputEventKey and event.pressed and not event.echo:
		var i: int = event.keycode - KEY_1
		if i >= 0 and i < tower_types.size():
			start_placing(tower_types[i])
			return
	if ghost == null:
		return
	if event.is_action_pressed("ui_cancel"):
		cancel()
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_try_place()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			cancel()

func _try_place() -> void:
	var pos := get_global_mouse_position()
	if not _is_valid(pos) or Game.credits < ghost_data.cost:
		return
	Game.credits -= ghost_data.cost
	ghost.modulate = Color.WHITE
	ghost.show_range = false
	ghost.active = true
	ghost.add_to_group("towers")
	var data := ghost_data
	ghost = null
	start_placing(data)  # stay in placement mode; cancels itself if you can't afford another

func _is_valid(pos: Vector2) -> bool:
	var local := path.to_local(pos)
	var closest := path.curve.get_closest_point(local)
	if local.distance_to(closest) < PATH_CLEARANCE:
		return false
	for t in get_tree().get_nodes_in_group("towers"):
		if t.global_position.distance_to(pos) < TOWER_SPACING:
			return false
	return true
