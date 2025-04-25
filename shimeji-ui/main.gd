extends Node2D

@onready var fd_upload = $UploadShimeji
var has_private_config = false
var image_path: Array[String] = []
var relative_path = ""

@onready var shimeji_preview = $Shimeji

func _ready():
	fd_upload.current_dir = "/"
	fd_upload.file_mode = FileDialog.FILE_MODE_OPEN_DIR


var action_parser := ShimejiActionParser.new()
func _on_upload_shimeji_dir_selected(dir: String) -> void:
	print(dir)
	image_path.clear()
	relative_path = dir
	var folder = DirAccess.open(dir)
	if folder == null:
		print("Could not open folder: ", dir)
		return

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

	if has_private_config:
		var xml_path = dir.path_join("conf/actions.xml")
		var actions = action_parser.parse_actions(xml_path)
		print("Number of Actions: ", actions.size())
		if actions.size() > 0:
			preview_animation(actions[3])
		else:
			print("No valid actions in XML.")

	#print("Loaded image paths: ", image_path)
	pass

func _on_button_pressed() -> void:
	fd_upload.visible = true

func create_animation(name: String, image_paths: Array[String]) -> SpriteFrames:
	print("Creating Animation: ", name)
	var frames = SpriteFrames.new()
	frames.add_animation(name)

	for path in image_paths:
		print(path)
		var image = Image.new()
		var err = image.load(relative_path + path)
		if err == OK:
			var tex = ImageTexture.create_from_image(image)
			frames.add_frame(name, tex)
		else:
			print("Failed to load image: ", path, " (Error code: ", err, ")")

	return frames

func preview_animation(action: ShimejiAction):
	print("Previewing all animations from Action: ", action.name)
	if action.animations.is_empty():
		print("No animations to show.")
		return

	var image_paths: Array[String] = []
	for anim in action.animations:
		for pose in anim.poses:
			image_paths.append(pose.image_path)

	var sprite_frames = create_animation("preview", image_paths)
	shimeji_preview.frames = sprite_frames
	shimeji_preview.play("preview")
