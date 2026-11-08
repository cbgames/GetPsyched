extends Control

@onready var steps : Array[Control] = [
	%IntroScreen1, %TestScreen1, %IntroScreen2, %TestScreen2, %ResultScreen
]
var step_index : int = 0

func _ready() -> void:
	_update_displayed_screen()

func _update_displayed_screen() -> void:
	for i in len(steps):
		if i == step_index:
			steps[i].visible = true
		else:
			steps[i].visible = false

func _on_screen_complete() -> void:
	step_index += 1
	if step_index >= len(steps):
		step_index = 0
	_update_displayed_screen()
