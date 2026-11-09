extends Button

@export var delay : float = 5

func _ready() -> void:
	visibility_changed.connect(on_visibility_changed)

func on_visibility_changed() -> void:
	if is_node_ready() and is_visible_in_tree():
		disabled = true
		await get_tree().create_timer(delay).timeout
		disabled = false
