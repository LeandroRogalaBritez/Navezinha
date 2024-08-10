extends Node2D

@export var speed: float = 200
@export var rotation_speed: float = 1
@export var speedY: float = 50 
var directionX = 1
var directionY = 1
var rotationDirection = 1;

func _ready() -> void:
	var random_index = randi() % (10 - 1 + 1) + 1
	var texture_path = "res://resources/Meteor_" + str(random_index) + ".png"
	$Sprite2D.texture = load(texture_path)
	z_index = -1
	rotationDirection = random_direction()
	directionY = random_direction()
	position.y = randf() * get_viewport().size.y
	position.x = random_direction_x()
	if position.x != 0:
		directionX = -1

func _process(delta: float) -> void:
	position.x += speed * delta * directionX
	position.y += speedY * delta * directionY
	rotation += rotation_speed * delta * rotationDirection
	if not get_viewport_rect().has_point(position):
		queue_free()
		
func random_direction():
	return 1 if randf() > 0.5 else -1
	
func random_direction_x():
	return 0 if random_direction() == 1 else get_viewport().size.x
