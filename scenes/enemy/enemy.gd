extends Area2D

@export var max_health: int = 100
var current_health: int
@onready var health_bar = $HealthBar
var shot_enemy_scene: PackedScene
var timer
var sprite_width
@export var shoot_chance: float = 0.45
var powerup_scene: PackedScene

func _ready() -> void:
	var sprite = get_node("Sprite2D") as Sprite2D
	sprite_width = sprite.texture.get_size().x * sprite.scale.x
	current_health = max_health
	shot_enemy_scene = load('res://scenes/shoteEnemy/shot_enemy.tscn') as PackedScene
	powerup_scene = load('res://scenes/powerUp/power_up.tscn') as PackedScene
	timer = Timer.new()
	timer.wait_time = 1.0
	timer.one_shot = false
	timer.connect("timeout", shoot)
	add_child(timer)
	timer.start()
	update_health_bar()

func _process(delta: float) -> void:
	pass

func take_damage(amount: int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_bar():
	health_bar.value = current_health

func die():
	if randi() % 100 < 20:
		var powerup_instance = powerup_scene.instantiate()
		powerup_instance.position = position
		get_tree().root.add_child(powerup_instance)
	queue_free()
	
func shoot():
	if randf() < shoot_chance:
		var shot = shot_enemy_scene.instantiate()
		shot.position = Vector2(position.x + (sprite_width / 2) - 5 , position.y + 100)
		add_child(shot)

func move(motion: Vector2):
	position += motion
