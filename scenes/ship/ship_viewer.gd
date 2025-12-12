extends Node2D

@export var rotate_speed_degrees: float = 90.0
@export var auto_rotate_speed_degrees: float = 15.0
@onready var ship_sprite: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
        _apply_manual_rotation(delta)
        _apply_auto_rotation(delta)

func _apply_manual_rotation(delta: float) -> void:
        var rotate_dir := 0.0
        if Input.is_action_pressed("right"):
                rotate_dir += 1.0
        if Input.is_action_pressed("left"):
                rotate_dir -= 1.0
        if rotate_dir != 0.0:
                ship_sprite.rotation_degrees = fposmod(ship_sprite.rotation_degrees + rotate_dir * rotate_speed_degrees * delta, 360.0)

func _apply_auto_rotation(delta: float) -> void:
        ship_sprite.rotation_degrees = fposmod(ship_sprite.rotation_degrees + auto_rotate_speed_degrees * delta, 360.0)

func _on_back_button_pressed() -> void:
        get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
