extends Area2D

@export var speed: float = 400
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	animated_sprite.play("Flying")
	set_as_top_level(true)

func _process(delta):
	position += Vector2(0, speed * delta * 1)
	if not get_viewport_rect().has_point(position):
		queue_free()

func _on_area_entered(area: Area2D) -> void:
	if (area.is_in_group('Ship')):
		animated_sprite.play("Explosion")
		area.take_damage(25)
		speed = 0

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
