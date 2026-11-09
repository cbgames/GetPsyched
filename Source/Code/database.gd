extends Node

const SAVE_PATH : String = "user://data.cfg"

var file = null
var trial_data = {}

func _ready() -> void:
	file = ConfigFile.new()
	load_from_file()

func load_from_file() -> void:
	if file.load(SAVE_PATH) == OK:
		trial_data = file.get_value("data", "trials", {})

func save_to_file() -> void:
	file.set_value("data", "trials", trial_data)
	file.save(SAVE_PATH)

func clear_trial_data() -> void:
	trial_data = {}

func append_trial(id : String, trial={}) -> void:
	if !trial.is_empty():
		trial_data[id] = trial 

func debug_string() -> String:
	return str(trial_data)
