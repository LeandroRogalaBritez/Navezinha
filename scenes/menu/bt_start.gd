extends Button

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass


func _on_button_down() -> void:
	get_tree().change_scene_to_file('res://scenes/level/level.tscn')
