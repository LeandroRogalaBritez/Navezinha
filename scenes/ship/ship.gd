extends Area2D

@export var speed = 200
var base_speed := 200
@export var shoot_cooldown: float = 1.0
@onready var shoot_cooldown_timer = $ShootCooldown
var sprite_width
var shot_scene: PackedScene
@export var max_health: int = 100
var current_health: int
@onready var health_bar = $HealthBar
var number_shoot = 1
var extra_damage = 0
var shot_timer: Timer
var remaining_shots: int = 0
@export var shot_delay: float = 0.1  # Delay de 0.1 segundos entre os tiros
var level_scene_instance
var level: int = 1
var current_xp: int = 0
var xp_to_next: int = 0
var stat_points: int = 0
var strength_points: int = 0
var speed_points: int = 0
var defense_points: int = 0
const BASE_DAMAGE := 50
const STRENGTH_BONUS := 10
const SPEED_BONUS := 25
const DEFENSE_REDUCTION := 5

func _ready() -> void:
    level_scene_instance = get_parent().get_tree().root.get_node("Level")
    base_speed = speed

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
    reset_phase_progress()

func update_health_bar():
    health_bar.value = current_health

func die():
    get_tree().reload_current_scene()

func reset_phase_progress():
    level = 1
    current_xp = 0
    xp_to_next = calculate_xp_to_next(level)
    stat_points = 0
    strength_points = 0
    speed_points = 0
    defense_points = 0
    speed = base_speed
    apply_speed_bonus()
    level_scene_instance.update_progress_ui(level, current_xp, xp_to_next, stat_points)
    level_scene_instance.update_stats_ui(strength_points, speed_points, defense_points)
    level_scene_instance.updateLbDamage("Dano: " + str(get_total_damage()))

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
    var mitigated_damage = max(1, amount - (defense_points * DEFENSE_REDUCTION))
    current_health -= mitigated_damage
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
    level_scene_instance.updateLbDamage("Dano: " + str(get_total_damage()))

func calculate_xp_to_next(current_level: int) -> int:
    return 60 + ((current_level - 1) * 25)

func add_experience(amount: int):
    current_xp += amount
    while current_xp >= xp_to_next:
        current_xp -= xp_to_next
        level += 1
        stat_points += 1
        xp_to_next = calculate_xp_to_next(level)
    update_progress_ui()

func update_progress_ui():
    level_scene_instance.update_progress_ui(level, current_xp, xp_to_next, stat_points)
    level_scene_instance.update_stats_ui(strength_points, speed_points, defense_points)
    level_scene_instance.updateLbDamage("Dano: " + str(get_total_damage()))

func allocate_point(stat: String):
    if stat_points <= 0:
        return
    match stat:
        "strength":
            strength_points += 1
            level_scene_instance.updateLbDamage("Dano: " + str(get_total_damage()))
        "speed":
            speed_points += 1
            apply_speed_bonus()
        "defense":
            defense_points += 1
    stat_points -= 1
    update_progress_ui()

func apply_speed_bonus():
    speed = base_speed + (speed_points * SPEED_BONUS)
    level_scene_instance.update_stats_ui(strength_points, speed_points, defense_points)

func get_total_damage() -> int:
    return BASE_DAMAGE + extra_damage + (strength_points * STRENGTH_BONUS)

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
    shot.set_damage(get_total_damage())
    add_child(shot)
    remaining_shots -= 1
