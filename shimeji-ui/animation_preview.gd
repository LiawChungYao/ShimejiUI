extends Node

class_name AnimationPreview
var shimeji_preview

func initialize(sprite : AnimatedSprite2D) -> void:
	shimeji_preview = sprite

func create_animation(name: String, image_paths: Array[String], durations: Array[int]) -> SpriteFrames:
	print("Creating Animation: ", name)
	var frames = SpriteFrames.new()
	frames.add_animation(name)
	
	for i in range(image_paths.size()):
		var path = image_paths[i].lstrip("/")
		var image = Image.new()
		var err = image.load(path)

		if err == OK:
			var tex = ImageTexture.create_from_image(image)
			# Add frame multiple times to simulate longer duration
			var repeat = durations[i] / 6  # Assume base frame duration is ~6 ticks
			repeat = max(1, repeat)  # Always show at least once
			for _j in repeat:
				frames.add_frame(name, tex)
		else:
			print("Failed to load image: ", path, " (Error code: ", err, ")")

	return frames
	
func preview_animation(action_dict: Dictionary):
	print("Previewing animation from Action:", action_dict.get("attributes", {}).get("Name", "Unknown"))

	var image_paths: Array[String] = []
	var durations: Array[int] = []

	# Find <Animation> node inside action
	for child in action_dict.get("children", []):
		if child.get("name") == "Animation":
			for pose in child.get("children", []):
				if pose.get("name") == "Pose":
					var img_path = pose.get("attributes", {}).get("Image", "")
					var duration = pose.get("attributes", {}).get("Duration", "6").to_int()
					if img_path != "":
						image_paths.append(img_path)
						durations.append(duration)
	
	if image_paths.is_empty():
		print("No poses found for animation.")
		return

	var sprite_frames = create_animation(action_dict.get("attributes", {}).get("Name", "Unknown"), image_paths, durations)
	shimeji_preview.frames = sprite_frames
	shimeji_preview.play(action_dict.get("attributes", {}).get("Name", "Unknown"))
	
func what() -> void:
	print("Shit")
