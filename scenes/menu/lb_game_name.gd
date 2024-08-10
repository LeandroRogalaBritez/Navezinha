extends Label

var text_to_display
var current_index
var timer

func _ready() -> void:
	text_to_display = text
	_resetText()
	timer = Timer.new()
	timer.wait_time = 0.2
	timer.one_shot = false
	timer.connect("timeout", _on_Timer_timeout)
	add_child(timer)
	timer.start()

func _process(delta: float) -> void:
	pass
	
func _on_Timer_timeout() -> void:
	if current_index < text_to_display.length():
		_nextChar()
		return
	_resetText()

func _nextChar() -> void:
	text += text_to_display[current_index]
	current_index += 1

func _resetText() -> void:
	current_index = 0
	text = text_to_display[current_index]
	current_index += 1
