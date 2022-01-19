extends HBoxContainer

var sprite_data
var current_animation = 0
var animations = ['idle_front', 'idle_right', 'idle_back', 'idle_left']

signal signal_test(name)

func init(_sprite_data):
	sprite_data = _sprite_data
	$SpriteName.text = sprite_data.name
	g.load_sprite($SpriteContainer/PlayerSprites/SpriteHolder, sprite_data)
	

func _ready():
	$SpriteContainer/PlayerSprites/AnimationPlayer.play(animations[current_animation])


func _on_Edit_button_up():
	pass

func _on_Delete_button_up():
	emit_signal("signal_test", sprite_data.name)

func _on_Turn_button_up(direction):
	current_animation += direction
	if current_animation == 4 or current_animation == -4:
		current_animation = 0
	$SpriteContainer/PlayerSprites/AnimationPlayer.play(animations[current_animation])
