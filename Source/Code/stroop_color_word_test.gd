extends Control

@onready var steps : Array[Control] = [
	%IntroScreen1, %TestScreen1, %IntroScreen2, %TestScreen2, %ResultScreen
]
var step_index : int = 0
var trial_id : String = ""
var trial_data = null

func _ready() -> void:
	randomize()
	_update_displayed_screen()

func _update_displayed_screen() -> void:
	for i in len(steps):
		if i == step_index:
			steps[i].visible = true
		else:
			steps[i].visible = false

func _on_screen_complete(data=null) -> void:
	match step_index:
		0:
			start_new_trial()
		1:
			if data:
				print({ "word_matching" : data })
				add_data_to_trial("word_matching", data)
		3:
			if data:
				print({ "color_matching" : data })
				add_data_to_trial("color_matching", data)
			_update_result_text()
			store_trial_data()
	step_index += 1
	if step_index >= len(steps):
		step_index = 0
	_update_displayed_screen()

func _update_result_text() -> void:
	var id = trial_id
	var test_result = trial_data.word_matching
	var correct = test_result.correct
	var incorrect = test_result.incorrect
	var time = test_result.time
	var accuracy = correct * 100 / (correct + incorrect)
	%ResultText.text = "[b]End Of Test[/b]\nId: " + str(id)
	%ResultText.text += "\n\nWord Matching\nAccuracy: " + str(accuracy) + "% in " + str(time)
	%ResultText.text += " seconds\n(Correct " + str(correct) + ", Incorrect " + str(incorrect) + ")"
	test_result = trial_data.color_matching
	correct = test_result.correct
	incorrect = test_result.incorrect
	time = test_result.time
	accuracy = correct * 100 / (correct + incorrect)
	%ResultText.text += "\n\nColor Matching\nAccuracy: " + str(accuracy) + "% in " + str(time)
	%ResultText.text += " seconds\n(Correct " + str(correct) + ", Incorrect " + str(incorrect) + ")"

func start_new_trial() -> void:
	trial_id = Time.get_datetime_string_from_system()
	trial_data = {}

func add_data_to_trial(key, data) -> void:
	trial_data[key] = data

func store_trial_data() -> void:
	Database.append_trial(trial_id, trial_data)
	print(Database.debug_string())
