extends PathFollow2D
class_name Enemy

signal died
signal escaped

@export var data: EnemyData
var health: float
var dead := false

func _ready() -> void:
	health = data.max_health
	add_to_group("enemies")

func _process(delta: float) -> void:
	progress += data.move_speed * delta
	if progress_ratio >= 1.0 and not dead:
		dead = true
		Game.lives -= 1
		escaped.emit()
		queue_free()

func take_damage(amount: float) -> void:
	if dead:
		return  # stops double-kills when two towers hit in the same frame
	health -= amount
	if health <= 0.0:
		dead = true
		Game.credits += data.reward
		died.emit()
		queue_free()
		
