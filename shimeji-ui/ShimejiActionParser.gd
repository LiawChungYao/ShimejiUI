extends Node

class_name ShimejiActionParser

# Load custom classes
const ShimejiPose = preload("res://ShimejiPose.gd")
const ShimejiAnimation = preload("res://ShimejiAnimation.gd")
const ShimejiAction = preload("res://ShimejiAction.gd")

func parse_actions(xml_path: String) -> Array[ShimejiAction]:
	print("This is the XML file: ", xml_path)
	var xml := XMLParser.new()
	var actions: Array[ShimejiAction] = []
	
	if xml.open(xml_path) != OK:
		push_error("Failed to open XML file at %s" % xml_path)
		return actions
	
	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "Action":
			actions.append(parse_action(xml))
	
	return actions


func parse_action(xml: XMLParser) -> ShimejiAction:
	var action := ShimejiAction.new()

	# Parse Action attributes
	for n in range(xml.get_attribute_count()):
		var attr_name = xml.get_attribute_name(n)
		var attr_value = xml.get_attribute_value(n)
		
		match attr_name:
			"Name": action.name = attr_value
			"Type": action.type = attr_value
			"Class": action.action_class = attr_value
			"BorderType": action.border_type = attr_value
			"Condition": action.condition = attr_value
			_ : pass
	
	# Now move on to the nested XML elements (like Animation)
	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT:
			match xml.get_node_name():
				"Animation":
					action.animations.append(parse_animation(xml))
				_ : pass  # Handle other elements as needed (e.g., ActionReference)
		elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END and xml.get_node_name() == "Action":
			break  # End of current Action node
	
	return action


func parse_animation(xml: XMLParser) -> ShimejiAnimation:
	var animation := ShimejiAnimation.new()

	# Parse Animation attributes (if any)
	for n in range(xml.get_attribute_count()):
		var attr_name = xml.get_attribute_name(n)
		var attr_value = xml.get_attribute_value(n)
		
		match attr_name:
			"Condition": animation.condition = attr_value
			_ : pass
	
	# Now parse the nested Pose elements under Animation
	while xml.read() == OK:
		if xml.get_node_type() == XMLParser.NODE_ELEMENT and xml.get_node_name() == "Pose":
			animation.poses.append(parse_pose(xml))
		elif xml.get_node_type() == XMLParser.NODE_ELEMENT_END and xml.get_node_name() == "Animation":
			break  # End of current Animation node
	
	return animation


func parse_pose(xml: XMLParser) -> ShimejiPose:
	var pose := ShimejiPose.new()
	
	# Parse Pose attributes
	for n in range(xml.get_attribute_count()):
		var attr_name = xml.get_attribute_name(n)
		var attr_value = xml.get_attribute_value(n)
		
		match attr_name:
			"Image": pose.image_path = attr_value
			"ImageAnchor": pose.image_anchor = _parse_vector2(attr_value)
			"Velocity": pose.velocity = _parse_vector2(attr_value)
			"Duration": pose.duration_ms = int(attr_value)
			_ : pass  # Handle other attributes as needed
	
	return pose


func _parse_vector2(text: String) -> Vector2:
	var parts = text.split(",")
	if parts.size() != 2:
		return Vector2.ZERO
	return Vector2(parts[0].to_float(), parts[1].to_float())
