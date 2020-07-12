extends MarginContainer

func _unhandled_input(_event):
	if Input.is_action_just_pressed("restart"):
		if get_tree().change_scene("res://Level/Level.tscn") != OK:
			print_debug("An error occurred while attempting to change to the Level scene.")
