extends Area2D

@export var speed = 200
@export var shoot_cooldown: float = 1.0
@onready var shoot_cooldown_timer = $ShootCooldown
var sprite_width
var shot_scene: PackedScene
@export var max_health: int = 100
var current_health: int
@onready var health_bar = $HealthBar
@onready var lb_shot = $lbShot
@onready var lb_damage = $lbDamage
var number_shoot = 1
var extra_damage = 0
var shot_timer: Timer
var remaining_shots: int = 0
@export var shot_delay: float = 0.1  # Delay de 0.1 segundos entre os tiros
var level_scene_instance

func _ready() -> void:
	level_scene_instance = get_parent().get_tree().root.get_node("Level")

	var sprite = get_node("Sprite2D") as Sprite2D
	sprite_width = sprite.texture.get_size().x * sprite.scale.x
	shot_scene = load('res://scenes/shot/shot.tscn') as PackedScene
	shoot_cooldown_timer.wait_time = shoot_cooldown
	current_health = max_health
	
	shot_timer = Timer.new()
	shot_timer.wait_time = shot_delay
	shot_timer.one_shot = true
	shot_timer.connect("timeout", _on_shot_timer_timeout)
	add_child(shot_timer)
	
	update_health_bar()
	
func update_health_bar():
	health_bar.value = current_health

func die():
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()
	var move = 0
	if Input.is_action_pressed("right"):
		move = 1
	if Input.is_action_pressed("left"):
		move = -1
	if move != 0:
		position = Vector2(clamp(position.x + (speed * delta * move), 0, get_viewport().size.x - sprite_width), position.y)

func take_damage(amount: int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	update_health_bar()
	if current_health <= 0:
		die()
		
func extra_shot_apply():
	number_shoot += 1
	level_scene_instance.updateLbShot("Tiro: " + str(number_shoot))

func extra_damage_apply():
	extra_damage += 25
	level_scene_instance.updateLbDamage("Dano: " + str(50 + extra_damage))

func shoot():
	if shoot_cooldown_timer.is_stopped():
		remaining_shots = number_shoot
		doShoot()
		if remaining_shots > 0:
			shot_timer.start()
		shoot_cooldown_timer.start()

func _on_shot_timer_timeout():
	if remaining_shots > 0:
		doShoot()
		shot_timer.start()

func doShoot():
	var shot = shot_scene.instantiate()
	shot.position = Vector2(position.x + (sprite_width / 2) + 5 , position.y - 100)
	shot.set_damage(50 + extra_damage)
	add_child(shot)
	remaining_shots -= 1
