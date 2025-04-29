extends Node2D

@onready var fd_upload = $UploadShimeji
@onready var fd_button = $Button

var scrollbox:
	set(value):
		scrollbox = value

var has_private_config = false
var image_path: Array[String] = []:
	get:
		return image_path
		
var actions: Dictionary: #Don't use this
	get:
		return actions
		
var actions_components: Array:
	get:
		return actions_components
		
var actions_actual: Array:
	get:
		return actions_actual

var relative_path: String:
	get:
		return relative_path

func _ready():
	#fd_upload.current_dir = "/"
	fd_upload.current_dir = "E:\\Programming\\shimejiee\\img\\Shimeji"
	fd_upload.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	
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
		actions = parse_xml_to_dict(xml_path, dir)
		actions_actual = actions["children"][1]["children"]
		actions_components = actions["children"][0]["children"]
		scrollbox.populate_container(scrollbox.action_component_buttons())
		scrollbox.visible = true
	pass
	

func parse_xml_to_dict(path: String, dir: String) -> Dictionary:
	var xml = XMLParser.new()
	if xml.open(path) != OK:
		push_error("Failed to open XML file.")
		return {}
	
	relative_path = dir
	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT:
			return parse_node(xml)
	
	return {}

func parse_node(xml: XMLParser) -> Dictionary:
	var node_data = {
		"name": xml.get_node_name(),
		"attributes": {},
		"children": [],
		"text": ""
	}
	
	# Parse attributes
	for i in range(xml.get_attribute_count()):
		var key = xml.get_attribute_name(i)
		var val = xml.get_attribute_value(i)
		if key == "Image":
			val = relative_path.path_join(val)
		node_data["attributes"][key] = val

	# If it's a self-closing tag (e.g. <tag />)
	if xml.is_empty():
		return node_data

	# Loop through child nodes
	while xml.read() == OK:
		match xml.get_node_type():
			XMLParser.NODE_ELEMENT:
				node_data["children"].append(parse_node(xml))  # Recursive call
			XMLParser.NODE_TEXT:
				node_data["text"] += xml.get_node_data().strip_edges()
			XMLParser.NODE_ELEMENT_END:
				if xml.get_node_name() == node_data["name"]:
					break
	return node_data
