class_name AmbienceSound
extends AudioStreamPlayer


func _ready():
	# Signal connections.
	connect("finished", self, "_on_finished")


func _on_finished():
	# Loops the sound.
	
	play()

