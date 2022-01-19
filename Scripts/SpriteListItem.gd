extends HBoxContainer

var sprite_data


func init(_sprite_data):
	sprite_data = _sprite_data
	$SpriteName.text = sprite_data.name
	g.load_sprite($SpriteContainer/PlayerSprites/SpriteHolder, sprite_data)


func _ready():
	pass # Replace with function body.


func _on_Edit_button_up():
	pass

func _on_Delete_button_up():
	g.remove_sprite_by_name(sprite_data.name)
