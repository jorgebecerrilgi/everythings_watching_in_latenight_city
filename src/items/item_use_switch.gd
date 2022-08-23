class_name ItemUseSwitch
extends ItemUse

# Variables
var is_on = false


func _on_input_event(viewport, event, shape_idx):
	# Starts the progress timer when the item is on, and stops it when it's off.
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		is_on = not is_on
		if is_on:
			timer_progress.start()
			animation.play("on")
		else:
			timer_progress.stop()
			check_goal()
			animation.play("off")

