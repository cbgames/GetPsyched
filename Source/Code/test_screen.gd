class_name TestScreen
extends Screen

var colors : Array[String] = [ "red", "yellow", "green", "blue" ]

enum TestType { WordMatch, ColorMatch }
@export var type : TestType = TestType.WordMatch
@export var prompt_count : int = 20

@onready var Text : RichTextLabel = $Panel/VBoxContainer/RichTextLabel
@onready var Button1 = $Panel/VBoxContainer/HBoxContainer/Button1
@onready var Button2 = $Panel/VBoxContainer/HBoxContainer/Button2
@onready var Button3 = $Panel/VBoxContainer/HBoxContainer/Button3
@onready var Button4 = $Panel/VBoxContainer/HBoxContainer/Button4

var correct_button : int = randi() % len(colors)
var correct_count : int = 0
var incorrect_count : int = 0
var prompts_left : int = 0
var start_msec : int = 0

func _on_visibility_changed() -> void:
	if is_node_ready() and is_visible_in_tree():
		correct_count = 0
		incorrect_count = 0
		prompts_left = prompt_count
		start_msec = Time.get_ticks_msec()
		randomize_buttons()
		randomize_prompt()

func randomize_buttons() -> void:
	colors.shuffle()
	var color1 : String = colors[0]
	var color2 : String = colors[1]
	var color3 : String = colors[2]
	var color4 : String = colors[3]
	Button1.text = color1
	Button2.text = color2
	Button3.text = color3
	Button4.text = color4

func randomize_prompt() -> void:
	correct_button = (correct_button + (randi() % 4)) % 4
	var incorrect_button = (correct_button + 1 + (randi() % 3)) % 4
	match type:
		TestType.WordMatch:
			var word : String = colors[correct_button]
			var color : String = colors[incorrect_button]
			Text.text = "[b][color=" + color + "]" + word + "[/color][/b]"
		TestType.ColorMatch:
			var color : String = colors[correct_button]
			var word : String = colors[incorrect_button]
			Text.text = "[b][color=" + color + "]" + word + "[/color][/b]"

func button_test(value: int) -> void:
	if value==correct_button:
		correct_count += 1
		randomize_prompt()
	else:
		incorrect_count += 1
		randomize_prompt()
	$Panel/DebugLayer/DebugText.text = "Correct: " + str(correct_count) + "\nIncorrect: " + str(incorrect_count)
	prompts_left -= 1
	if prompts_left <= 0:
		var elapsed_seconds = ceili((Time.get_ticks_msec() - start_msec) / 1000.0)
		var results = { "correct" : correct_count, "incorrect" : incorrect_count, "time" : elapsed_seconds }
		emit_signal("screen_complete", results)

func _on_button_1_pressed() -> void:
	button_test(0)

func _on_button_2_pressed() -> void:
	button_test(1)

func _on_button_3_pressed() -> void:
	button_test(2)

func _on_button_4_pressed() -> void:
	button_test(3)
