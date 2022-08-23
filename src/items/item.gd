class_name Item
extends Area2D

# Variables
onready var animation: AnimationPlayer = $Animation


func _ready():
	# Signal connections.
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	connect("input_event", self, "_on_input_event")


func _on_mouse_entered():
	# Highlights the object when hovered over by the mouse.
	
	animation.play("hover")


func _on_mouse_exited():
	# Highlights the object when hovered over by the mouse.
	
	if input_pickable:
		animation.play("idle")


func _on_input_event(viewport, event, shape_idx):
	# Detects an input within the object's area.
	
	pass


func update_sprite(frame):
	# Updates the item's sprite if there are different types.
	
	if $Sprite.hframes != 1:
		$Sprite.frame = frame

