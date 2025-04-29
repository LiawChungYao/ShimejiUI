extends Node2D

@onready var shimeji = $AnimatedSprite2D
var fileloader:
	set(value):
		fileloader = value

var data: Array:
	set(value):
		data = value

func play_from_actions(anim_name: String) -> void:
	for n in fileloader.actions_components:
		if n["attributes"]["Name"] == anim_name:
			preview_animation(n)

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
	var animation_name = action_dict.get("attributes", {}).get("Name", "Unknown")
	print("Previewing animation from Action:", name)

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

	var sprite_frames = create_animation(name, image_paths, durations)
	play_animation(name, sprite_frames)



func play_animation(name: String, frames: SpriteFrames) -> void:
	shimeji.sprite_frames = frames
	shimeji.play(name)
