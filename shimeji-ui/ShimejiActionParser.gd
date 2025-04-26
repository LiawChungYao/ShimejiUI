extends Node

class_name ShimejiActionParser

var relative_path = ""

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
