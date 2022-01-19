extends Node2D

var sprite_list_item = preload("res://Scenes/SpriteListItem.tscn")

func _ready():
	pass


func _on_SpriteList_visibility_changed():
	if visible: # TODO: Make to where it reloads, not loads more
		var sprite_list = g.load_all_sprites()
		for sprite in sprite_list:
			print(sprite.name)
			var new_sprite_list_item = sprite_list_item.instance()
			new_sprite_list_item.init(sprite)
			$ScrollContainer/VBoxContainer.add_child(new_sprite_list_item)


func _on_Button_button_up():
	hide()
	get_parent().get_node("Main").show()
