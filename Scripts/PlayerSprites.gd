extends Node2D

var z_index_library: Dictionary
var frame = 0
var vframes = 8
var hframes = 8
var sprite_direction = "front"

func init(_frame, _vframes, _hframes, _direction):
	frame = _frame
	vframes = _vframes
	hframes = _hframes
	sprite_direction = _direction

func _ready():
	# Load your Z-index library once this node is ready
	z_index_library = load_json("res://Resources/JSON/z_index_player_library.json")

	# For each sprite (child) in SpriteHolder, set frames & tile counts
	for sprite in $SpriteHolder.get_children():
		sprite.frame = frame
		sprite.vframes = vframes
		sprite.hframes = hframes
	
	# Reorder them based on the direction
	set_node_indices(sprite_direction)

func _process(delta):
	pass

func load_json(file_path: String) -> Dictionary:
	var file = File.new()
	file.open(file_path, File.READ)
	var text = file.get_as_text()
	return JSON.parse(text).result

func set_node_indices(direction):
	for sprite in $SpriteHolder.get_children():
		var sprite_name = sprite.name
		var index_val = z_index_library.get(sprite_name, {}).get(direction, -1)

		# Sanity check: Ensure the index is valid
		if index_val == -1:
			print("⚠️ ERROR: Missing z-index for", sprite_name, "in direction:", direction)


func _on_AnimationPlayer_animation_started(anim_name: String):
	var direction = anim_name.split("_")[1]
	set_node_indices(direction)
