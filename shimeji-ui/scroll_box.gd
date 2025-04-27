extends Node2D

@onready var container = $VBoxContainer/ScrollContainer/VBoxContainer

func _ready() -> void:
	print("ScrollBox Ready")
	_populate_container(test_populate_container())
	
func test_populate_container() -> Array:
	var test_buttons = []
	
	for i in range(10):
		var curr_button := Button.new()
		curr_button.text = str(i)
		curr_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		test_buttons.append(curr_button)
	return test_buttons
	
func _populate_container(nodes: Array) -> void:
	for n in nodes:
		container.add_child(n)
		
