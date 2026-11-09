class_name Screen
extends MarginContainer

signal screen_complete()

func _on_complete_button_pressed() -> void:
	emit_signal("screen_complete")
