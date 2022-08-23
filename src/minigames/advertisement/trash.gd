class_name Trash
extends Node2D


func start(id):
	# Changes texture and plays throwing away animation.
	
	$Flyer.frame = id
	$Animation.play("throw")

