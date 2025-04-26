extends Node2D

@onready var fd_upload = $UploadShimeji
@onready var fd_button = $Button
@onready var shimeji = $Shimeji
@onready var search_bar = $VBoxContainer/HBoxContainer/LineEdit
@onready var block_container = $VBoxContainer/ScrollContainer/VBoxContainer


var has_private_config = false
var image_path: Array[String] = []
var relative_path = ""

var action_parser := ShimejiActionParser.new()
var load_actions := LoadActions.new()

func _ready():
	#fd_upload.current_dir = "/"
	fd_upload.current_dir = "E:\\Programming\\shimejiee\\img\\Shimeji"
	fd_upload.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	
	add_child(load_actions)
	block_container.custom_minimum_size = Vector2(400, 600)
	block_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	load_actions.initialize_node(block_container, search_bar, shimeji)

func _on_button_pressed() -> void:
	fd_upload.visible = true

func _on_upload_shimeji_dir_selected(dir: String) -> void:
	print(dir)
	relative_path = dir
	var folder = DirAccess.open(dir)
	# Valid folder check
	if folder == null:
		print("Could not open folder: ", dir)
		return

	fd_button.visible = false

	# Collect images
	folder.list_dir_begin()
	var file_name = folder.get_next()
	while file_name != "":
		if file_name == "conf":
			has_private_config = true
		if not folder.current_is_dir():
			var ext = file_name.get_extension().to_lower()
			if ext in ["png", "jpg", "jpeg"]:
				image_path.append(dir.path_join(file_name))
		file_name = folder.get_next()
	folder.list_dir_end()

	# Has a private config file
	if has_private_config:
		var xml_path = dir.path_join("conf/actions.xml")
		var actions = action_parser.parse_xml_to_dict(xml_path, dir)
		var action_list = actions["children"][0]
		var action_behaviour = actions["children"][1]
		load_actions.populate_action_blocks(action_list["children"])
		"""
		if action_list["children"].size() > 0:
			preview_animation(action_list["children"][10])
		else:
			print("No valid actions in XML.")"""
	pass
