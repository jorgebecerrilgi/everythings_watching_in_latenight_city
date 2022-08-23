class_name ItemUseHold
extends ItemUse


func _on_mouse_entered():
	# Plays holding animation.
	
	if animation.assigned_animation == "select":
		next_animation("hover")
	else:
		._on_mouse_entered()


func _on_mouse_exited():
	# Stops the progress timer when exiting the item's area.
	
	if not timer_progress.is_stopped():
		stop_progress()
	elif animation.assigned_animation == "select":
		next_animation("idle")
	else:
		._on_mouse_exited()


func _on_input_event(viewport, event, shape_idx):
	# Starts the progress timer when holding the item.
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		if event.pressed:
			timer_progress.start()
			animation.clear_queue()
			animation.play("select")
		elif not event.pressed and animation.assigned_animation == "select":
			stop_progress()


func stop_progress():
	# Stops the progress timer and plays the corresponding animation.
	
	timer_progress.stop()
	animation.play_backwards("select")
	yield(animation, "animation_finished")
	check_goal()


func next_animation(name: String):
	# Adds an animation to the queue and clears all others.
	
	animation.clear_queue()
	animation.queue(name)

