extends Resource
class_name TowerData

@export var unit_name: String = "Infantry Squad"
@export var nato_symbol: Texture2D
@export var cost: int = 100
@export var attack_damage: float = 15.0
@export var attack_range: float = 200.0
@export var deploy_sfx: AudioStream
@export var max_ammo: int = 10
@export var reload_time: float = 2.0
@export var fire_interval: float = 0.5  # renamed from fire_rate (it's seconds between shots)
