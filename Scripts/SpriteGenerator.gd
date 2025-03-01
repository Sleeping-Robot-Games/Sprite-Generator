extends Node2D

const PLAYER_SPRITES_SCENE = preload("res://Scenes/PlayerSprites.tscn")

# The grid dimensions
export(int) var rows = 8
export(int) var columns = 8

# Spritesheet total size (for 8×8 = 384×384)
export(int) var sheet_width = 384
export(int) var sheet_height = 384

# If you have fewer than 64 directions,
# you can cycle them by indexing with [i % frame_directions.size()].
var frame_directions = [
	"front",
	"left",
	"back",
	"right"
]

func _ready():
	pass

func create_spritesheet(state, parent = null):
	var cell_width = float(sheet_width) / columns  # 384 / 8 = 48
	var cell_height = float(sheet_height) / rows   # 384 / 8 = 48

	# We want 64 frames total in an 8×8 arrangement
	for i in range(rows * columns):
		# Calculate which row and column this frame belongs to
		var row = i / columns  # integer division
		var col = i % columns

		# If you only have 4 directions but 64 frames:
		# This will cycle directions: front, left, back, right, front, ...
		var direction = frame_directions[i % frame_directions.size()]

		# Create the sprite scene
		var frame_instance = PLAYER_SPRITES_SCENE.instance()

		# Pass a unique frame index (i), the total vframes/hframes, and a direction
		# The signature matches your PlayerSprites: init(_frame, _vframes, _hframes, _direction)
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
