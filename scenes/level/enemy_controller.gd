extends Node

@export var speed: float = 100
var direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	set_process(true)

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	
	for enemy in enemies:
		if enemy.position.x <= -10 or enemy.position.x >= get_viewport().size.x - 80:
			direction *= -1
			break

	for enemy in enemies:
		enemy.move(direction * speed * delta)
