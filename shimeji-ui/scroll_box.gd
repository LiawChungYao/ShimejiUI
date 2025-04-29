extends Node2D

var shimeji:
	set(value):
		shimeji = value
		
var fileloader:
	set(value):
		fileloader = value

@onready var container = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var search_box = $VBoxContainer/HBoxContainer/LineEdit
@onready var clear_search = $VBoxContainer/HBoxContainer/Button

func _ready() -> void:
	print("ScrollBox Ready")
	
func test_populate_container() -> Array:
	var test_buttons = []
	
	for i in range(10):
		var curr_button := Button.new()
		curr_button.text = str(i)
		curr_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		test_buttons.append(curr_button)
	return test_buttons
	
func action_component_buttons() -> Array:
	var all_buttons = []
	for n in fileloader.actions_components:
		var curr_button := Button.new()
		curr_button.text = n["attributes"]["Name"]
		curr_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		curr_button.pressed.connect(func(): _on_action_pressed(n["attributes"]["Name"]))
		all_buttons.append(curr_button)
	return all_buttons
	
func populate_container(nodes: Array) -> void:
	for n in nodes:
		container.add_child(n)

func _on_button_pressed() -> void:
	search_box.clear()
	pass # Replace with function body.
	
func _on_action_pressed(name: String) -> void:
	shimeji.play_from_actions(name)
	pass
