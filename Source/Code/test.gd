extends Control

const SAVE_PATH : String = "user://save_data.cfg"

var _seconds : float = 0;
var _counting : bool = false;

func _ready() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Button_Stop.visible = false

func _process(delta: float) -> void:
	if _counting:
		_seconds += delta
	$MarginContainer/VBoxContainer/HBoxContainer/LineEdit.text = "%d seconds" % _seconds

func _on_button_start_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Button_Start.visible = false
	$MarginContainer/VBoxContainer/HBoxContainer/Button_Stop.visible = true
	_counting = true

func _on_button_stop_pressed() -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/Button_Start.visible = true
	$MarginContainer/VBoxContainer/HBoxContainer/Button_Stop.visible = false
	_counting = false

func _on_button_save_pressed() -> void:
	var config = ConfigFile.new()
	config.set_value("test", "seconds", _seconds)
	config.save(SAVE_PATH)

func _on_button_load_pressed() -> void:
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		_seconds = config.get_value("test", "seconds", 0)
