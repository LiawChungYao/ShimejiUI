extends Node

class_name LoadActions
var AnimationPreview = preload("res://animation_preview.gd")
var preview_anim = AnimationPreview.new()
var block_container
var search_bar

var all_actions: Array = []
	
func initialize_node(container : VBoxContainer, search : LineEdit, sprite : AnimatedSprite2D) -> void:
	block_container = container
	search_bar = search
	preview_anim.initialize(sprite)
	
func clear_container() -> void:
	if block_container:
		for child in block_container.get_children():
			child.queue_free()
	
func _on_line_edit_text_changed(new_text: String) -> void:
	pass # Replace with function body.
	_display_filtered_blocks(new_text)

func populate_action_blocks(actions: Array) -> void:
	all_actions = actions
	_display_filtered_blocks("")

func _display_filtered_blocks(filter: String) -> void:
	clear_container()
	for action_data in all_actions:
		var action_name = action_data.get("name", "").to_lower()
		if filter.to_lower() in action_name or filter == "":
			print("Creating action block for: ", action_data.get("name", "Unknown"))
			var block = create_action_block(action_data)
			block_container.add_child(block)

func create_action_block(action_data: Dictionary) -> Control:
	var button = Button.new()
	button.custom_minimum_size = Vector2(200, 50)
	button.text = action_data["attributes"]["Name"]
	print(button.disabled)
	button.pressed.connect(func(): preview_action_by_name(action_data["attributes"]["Name"]))
	
	return button
	
func preview_action_by_name(action_name: String) -> void:
	print("Pressed")
	for action in all_actions:
		if action["attributes"]["Name"] == action_name:
			preview_anim.preview_animation(action)
			return
	print("Action not found: ", action_name)

func test_button():
	print("Hello")
