extends Node2D

@onready var fd_upload = $UploadShimeji
var has_private_config = false
var image_path = []

func _ready():
	fd_upload.current_dir = "/"
	fd_upload.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	

func _on_upload_shimeji_dir_selected(dir: String) -> void:
	print(dir)
	# Open folder
	var folder = DirAccess.open(dir)
	
	if folder == null: # Failed to open folder
		print("Could not open folder: ", folder)
		return
		
		
	folder.list_dir_begin()
	var file_name = folder.get_next()	
	while file_name != "":
		print(file_name)
		# Check if the shimeji has a personal config folder
		if file_name == "conf":
			has_private_config = true
		if not folder.current_is_dir():
			# Collect all shimeji assets
			var ext = file_name.get_extension().to_lower()
			if ext in ["png", "jpg", "jpeg"]:
				image_path.append(dir + "/" + file_name)
		file_name = folder.get_next()
	folder.list_dir_end()
	print(image_path)
	preview_animation(image_path)
	pass # Replace with function body.


func _on_button_pressed() -> void:
	fd_upload.visible = true
	pass # Replace with function body.
	
func create_animation(name: String, image_paths: Array) -> SpriteFrames:
	print("Create Animation")
	var frames = SpriteFrames.new()
	frames.add_animation(name)
	frames.set_animation_loop(name, true)

	for path in image_paths:
		var image = Image.new()
		var err = image.load(path)
		if err == OK:
			var tex = ImageTexture.create_from_image(image)
			frames.add_frame(name, tex)
		else:
			print("Failed to load image: ", path, " (Error code: ", err, ")")
	
	return frames
	
@onready var shimeji_preview = $Shimeji

func preview_animation(image_paths: Array):
	print("Preview Animation")
	var sprite_frames = create_animation("preview", image_paths)
	shimeji_preview.frames = sprite_frames
	shimeji_preview.play("preview")
