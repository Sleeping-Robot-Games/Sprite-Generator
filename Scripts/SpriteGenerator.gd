extends Node2D

const PLAYER_SPRITES_SCENE = preload("res://Scenes/PlayerSprites.tscn")

# The grid dimensions
export(int) var rows = 8
export(int) var columns = 8

# Spritesheet total size (for 8×8 = 384×384)
export(int) var sheet_width = 384
export(int) var sheet_height = 384

# Cycle directions 4 frames at a time:
var frame_directions = [
	"front",
	"back",
	"left",
	"right"
]

func _ready():
	pass

func create_spritesheet(state, parent = null):
	var target = parent if parent else $ViewportContainer/Viewport
	for frame in target.get_children():
		frame.queue_free()
		
	var cell_width = float(sheet_width) / columns  # e.g. 384 / 8 = 48
	var cell_height = float(sheet_height) / rows   # e.g. 384 / 8 = 48

	# We want 64 frames total in an 8×8 arrangement
	for i in range(rows * columns):
		# Calculate which row and column this frame belongs to
		var row = int(i / columns)
		var col = i % columns

		# Determine direction in blocks of 4 frames:
		var direction_index = int(i / 4) % frame_directions.size()
		var direction = frame_directions[direction_index]

		# Create the sprite scene
		var frame_instance = PLAYER_SPRITES_SCENE.instance()

		# Pass a unique frame index (i), the total vframes/hframes, and a direction
		frame_instance.init(
			i,            # unique frame index
			rows,         # total vertical frames = 8
			columns,      # total horizontal frames = 8
			direction
		)
		
		# Center the instance within its (col, row) cell
		frame_instance.position = Vector2(
			(col + 0.5) * cell_width,
			(row + 0.5) * cell_height
		)
	
		if parent:
			parent.add_child(frame_instance)
		else:
			# Add it to the viewport for rendering
			$ViewportContainer/Viewport.add_child(frame_instance)
			
		# Apply the sprite_state
		frame_instance.create_character(state)


func export_spritesheet():
	show()
	# Start a short timer to allow the viewport to render before capturing
	$Timer.start()

func _on_Timer_timeout():
	save_img()

func save_img():
	var image = $ViewportContainer/Viewport.get_texture().get_data()
	image.convert(Image.FORMAT_RGBA8)
	image.flip_y()

	var file_name = "spritesheet_%s.png" % str(OS.get_ticks_msec())
	var file_path = "user://%s" % file_name
	var err = image.save_png(file_path)
	if err == OK:
		print("Saved spritesheet to: %s" % file_path)
	else:
		print("Error saving image: ", err)
