extends Node

func _ready():
	pass # Replace with function body.
	
func files_in_dir(path: String, keyword: String = "") -> Array:
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif keyword != "" and file.find(keyword) == -1:
			continue
		elif not file.begins_with(".") and not file.ends_with(".import"):
			files.append(file)
	dir.list_dir_end()
	return files
	
func save_sprite(sprite_state: Dictionary, palette_state: Dictionary, player_name: String):
	var f: File = File.new()
	f.open("user://characters.save", File.READ_WRITE)
	var json: JSONParseResult = JSON.parse(f.get_as_text())
	f.close()
	var data_array: Array = json.result if json.result != null else []
	var state = {
		"name": player_name,
		"sprite_state": sprite_state,
		"palette_state": palette_state
	}
	data_array.append(state)
	# Save
	f = File.new()
	f.open("user://characters.save", File.WRITE)
	f.store_string(JSON.print(data_array, "  ", true))
	f.close()

func load_all_sprites():
	var f = File.new()
	f.open("user://characters.save", File.READ)
	var json = JSON.parse(f.get_as_text())
	f.close()
	if not json.result:
		return []
	else:
		var character_array: Array = json.result
		## TEMP TO REMOVE NO NAMES
		character_array = remove_sprites_with_no_names(character_array)
		f = File.new()
		f.open("user://characters.save", File.WRITE)
		f.store_string(JSON.print(character_array, "  ", true))
		f.close()
		##
		return character_array
	
func load_sprite_from_name(parent_node: Node2D, sprite_name: String):
	var f = File.new()
	f.open("user://characters.save", File.READ)
	var json = JSON.parse(f.get_as_text())
	f.close()
	var character_array: Array = json.result
	var sprite = find_sprite_by_name(character_array, sprite_name)
	for part in parent_node.get_children():
		if part.name == "JacketB":
			continue
		if part.name in sprite.sprite_state.keys():
			part.texture = load(sprite.sprite_state[part.name])
		else:
			continue
		var folder = get_palette_folder_name_from_sprite(part)
		var number = sprite.palette_state[folder]
		set_sprite_color(folder, part, number)

func load_sprite(sprite_holder: Node2D, state: Dictionary):
	for part in sprite_holder.get_children():
		if part.name == "JacketB":
			continue
		if part.name in state.sprite_state.keys():
			#if not part.name in state.sprite_state.keys():
			part.texture = load(state.sprite_state[part.name])
		else:
			continue
		var folder = get_palette_folder_name_from_sprite(part)
		var number = state.palette_state[folder]
		set_sprite_color(folder, part, number)

func get_palette_folder_name_from_sprite(sprite: Sprite):
	var reverse_palette_dictionary = {
		'Accessory1': 'Accessory1',
		'Accessory2': 'Accessory2',
		'Accessory3': 'Accessory3',
		'Arms': 'Skintone',
		'Body': 'Skintone',
		'BottomA': 'Bottom',
		'BottomB': 'Bottom',
		'Eyes': 'Eye',
		'HairA': 'Hair',
		'HairB': 'Hair',
		'HairC': 'Hair',
		'HairD': 'Hair',
		'Head': 'Skintone',
		'JacketA': 'Jacket',
		'JacketB': 'Jacket',
		'Shoes': 'Shoe',
		'TopA': 'Top',
		'TopB': 'Top'
	}
	return reverse_palette_dictionary[sprite.name]

func set_sprite_color(folder, sprite: Sprite, number: String) -> void:
	var palette_path = "res://Assets/Palettes/{folder}/{folder}color_{number}.png".format({
		"folder": folder,
		"number": number
	})
	var gray_palette_path = "res://Assets/Palettes/{folder}/{folder}color_000.png".format({
		"folder": folder
	})
	sprite.material.set_shader_param("palette_swap", load(palette_path))
	sprite.material.set_shader_param("greyscale_palette", load(gray_palette_path))
	make_shaders_unique(sprite)

func make_shaders_unique(sprite: Sprite):
	var mat = sprite.get_material().duplicate()
	sprite.set_material(mat)
	
func find_sprite_by_name(character_array: Array, character_name: String):
	for character in character_array:
		if character.name == character_name:
			return character

func remove_sprites_with_no_names(character_array: Array):
	for character in character_array:
		if character.name == '':
			character_array.erase(character)
	return character_array

func remove_sprite_by_name(character_name: String):
	var sprite_array = load_all_sprites()
	var sprite_to_delete = find_sprite_by_name(sprite_array, character_name)
	sprite_array.erase(sprite_to_delete)
	var f = File.new()
	f.open("user://characters.save", File.WRITE)
	f.store_string(JSON.print(sprite_array, "  ", true))
	f.close()
	
func sprite_name_exists(p_name):
	var f = File.new()
	f.open("user://characters.save", File.READ_WRITE)
	var json = JSON.parse(f.get_as_text())
	f.close()
	if json.result:
		var character_array: Array = json.result
		for character in character_array:
			if character.name == p_name:
				return true
		return false
	return false
