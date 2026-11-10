extends Node2D
class_name Tower

@export var data: TowerData
@onready var ammo_bar: ProgressBar = $ProgressBar

var ammo: int
var cooldown := 0.0
var reloading := false
var reload_left := 0.0
var active := true  # false = ghost preview, does nothing


func _ready() -> void:
	ammo = data.max_ammo
	ammo_bar.max_value = data.max_ammo
	ammo_bar.value = ammo

func _process(delta: float) -> void:
	cooldown -= delta
	if not active:
		return

	if reloading:
		reload_left -= delta
		# bar visibly refills while reloading
		ammo_bar.value = data.max_ammo * (1.0 - reload_left / data.reload_time)
		if reload_left <= 0.0:
			reloading = false
			ammo = data.max_ammo
			ammo_bar.value = ammo
		return

	var target := _find_target()
	if target == null:
		return
	if cooldown <= 0.0:
		_shoot(target)

func _shoot(target: Enemy) -> void:
	target.take_damage(data.attack_damage)

	ammo -= 1
	ammo_bar.value = ammo
	cooldown = data.fire_interval
	if ammo <= 0:
		reloading = true
		reload_left = data.reload_time

func _find_target() -> Enemy:
	var best: Enemy = null
	for e in get_tree().get_nodes_in_group("enemies"):
		if global_position.distance_to(e.global_position) <= data.attack_range:
			if best == null or e.progress > best.progress:
				best = e
	return best

var show_range := false:

	set(v):
		show_range = v
		queue_redraw()

func _draw() -> void:
	if show_range:
		draw_circle(Vector2.ZERO, data.attack_range, Color(1, 1, 1, 0.12))
		draw_arc(Vector2.ZERO, data.attack_range, 0.0, TAU, 64, Color(1, 1, 1, 0.5), 2.0)
