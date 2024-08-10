extends Node2D

var enemy_widht
var meteor_scene: PackedScene
var enemy_scene: PackedScene
@export var meteor_spawn_rate: float = 2.0 
@onready var lb_phase = $lbPhase
@onready var lb_shot = $lbShot
@onready var lb_damage = $lbDamage
var spawn_timer: Timer
@export var initial_enemy_count: int = 1
var current_enemy_count: int
var current_phase: int = 0
var enemy_height

func _ready() -> void:
	spawn_timer = Timer.new()
	spawn_timer.wait_time = meteor_spawn_rate
	spawn_timer.autostart = true
	spawn_timer.one_shot = false
	spawn_timer.connect("timeout", spawn_meteor)
	add_child(spawn_timer)
	
	meteor_scene = load('res://scenes/meteor/meteor.tscn') as PackedScene
	enemy_scene = load('res://scenes/enemy/enemy.tscn') as PackedScene
	
	var enemy_example = enemy_scene.instantiate()
	var sprite_enemy = enemy_example.get_node("Sprite2D") as Sprite2D
	enemy_widht = (sprite_enemy.texture.get_size().x * sprite_enemy.scale.x) + 30
	enemy_height = (sprite_enemy.texture.get_size().y * sprite_enemy.scale.y) + 30
	enemy_example.queue_free()
	
func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() == 0:
		current_phase += 1
		lb_phase.text = "Fase: " + str(current_phase)
		start_phase(current_phase)

func start_phase(phase):
	current_enemy_count = initial_enemy_count + (phase - 1) * 2

	var screen_size = get_viewport().size
	var num_enemys_widht = int(floor(screen_size.x / enemy_widht))
	var line = 0;
	
	var count_enemy_line = 0
	for i in range(current_enemy_count):
		if (count_enemy_line == num_enemys_widht):
			line += 1
			count_enemy_line = 0
		var enemy_instance = enemy_scene.instantiate()
		enemy_instance.position = Vector2(count_enemy_line * enemy_widht, line * enemy_height)
		enemy_instance.add_to_group("enemies")
		add_child(enemy_instance)
		count_enemy_line += 1

func updateLbDamage(value):
	lb_damage.text = value

func updateLbShot(value):
	lb_shot.text = value

func spawn_meteor():
	var meteor = meteor_scene.instantiate()
	add_child(meteor)
