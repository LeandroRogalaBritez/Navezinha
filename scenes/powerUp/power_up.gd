extends Area2D

@export var effects = ["extra_shot", "extra_damage"]
@export var sprite_paths = [
	"res://resources/Rockets_Bonus.png",
	"res://resources/Damage_Bonus.png"
]
@export var speed: float = 400
var effect: String
var sprite_path: String

func _ready() -> void:
	randomize()
	effect = effects[randi() % effects.size()]
	sprite_path = sprite_paths[randi() % sprite_paths.size()]
	$Sprite2D.texture = load(sprite_path)

func _process(delta: float) -> void:
	position += Vector2(0, speed * delta * 1)
	if not get_viewport_rect().has_point(position):
		queue_free()

func apply_effect(player):
	match effect:
		"extra_shot":
			player.extra_shot_apply()
		"extra_damage":
			player.extra_damage_apply()


func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group('Ship')):
		apply_effect(area)
		queue_free()
