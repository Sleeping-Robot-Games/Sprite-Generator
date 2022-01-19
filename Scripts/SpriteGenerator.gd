extends Node2D

const player_sprites_scene = preload("res://Scenes/PlayerSprites.tscn")

export(int) var rows = 10
export(int) var columns = 2

var frame_directions = [
	'left',
	'back',
	'right',
	'front',
	'left',
	'left',
	'back',
	'back',
	'right',
	'right',
	'front',
	'front',
	'left',
	'left',
	'back',
	'back',
	'right',
	'right',
	'front',
	'front'
]

func _ready():
	var column_width = 1024 / columns
	var row_height = 1280 / rows
	
	for frame in range(0, rows * columns):
		var column = frame % 2 # only works for 2 columns
		var row_number = ceil((frame + 1.0) / 2.0)
		var frame_instance = player_sprites_scene.instance()
		frame_instance.init(frame, rows, columns, frame_directions[frame])
		frame_instance.global_position = Vector2(
			(column_width / 2) * 3 if column != 0 else (column_width / 2),
			(row_height * row_number) - (row_height / 2)
			)
		$ViewportContainer/Viewport.add_child(frame_instance)
		
func export_spritesheet(state):
	for player_sprites in $ViewportContainer/Viewport.get_children():
		var sprite_holder = player_sprites.get_node('SpriteHolder')
		g.load_sprite(sprite_holder, state)
	$Timer.start()

	

func save_img():
	var image = $ViewportContainer/Viewport.get_texture().get_data()
	image.convert(Image.FORMAT_RGBA8)
	image.flip_y()
	image.save_png("C:/Users/bryan/Desktop/test_screenshot.png")


func _on_Timer_timeout():
	save_img()
