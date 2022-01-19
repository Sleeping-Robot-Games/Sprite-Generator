extends Node2D

var sprite_list_item = preload("res://Scenes/SpriteListItem.tscn")

func _ready():
	pass

func _on_SpriteList_visibility_changed():
	if visible: 
		var sprite_list = g.load_all_sprites()
		for sprite in sprite_list:
			var new_sprite_list_item = sprite_list_item.instance()
			new_sprite_list_item.init(sprite)
			new_sprite_list_item.connect("signal_test", self, "_on_Delete_list_item")
			$ScrollContainer/VBoxContainer.add_child(new_sprite_list_item)
	else:
		for n in $ScrollContainer/VBoxContainer.get_children():
			n.queue_free()

func _on_Delete_list_item(sprite_name):
	# Remove sprite from list container
	for sprite in $ScrollContainer/VBoxContainer.get_children():
		if sprite.sprite_data.name == sprite_name:
			sprite.queue_free()
	# Remove sprite from save file
	g.remove_sprite_by_name(sprite_name)

func _on_Button_button_up():
	hide()
	get_parent().get_node("Main").show()
