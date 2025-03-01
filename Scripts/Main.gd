extends Node2D


func _ready():
	pass # Replace with function body.


func _on_Create_button_up():
	hide()
	get_parent().get_node("SpriteCreate").show()


func _on_List_button_up():
	hide()
	get_parent().get_node('SpriteList').show()


func _on_WindowChange_pressed():
	if not OS.window_fullscreen:
		OS.window_fullscreen = true
		$WindowChange.text = 'Windowed'
	else:
		OS.window_fullscreen = false
		OS.window_resizable = true
		$WindowChange.text = 'Full Screen'
		
