extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Create_button_up():
	hide()
	get_parent().get_node("SpriteCreate").show()


func _on_List_button_up():
	hide()
	get_parent().get_node('SpriteList').show()
