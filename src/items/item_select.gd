class_name ItemSelect
extends Item

# Signals
signal selected(id)

# Variables
export var id = 0


func _ready():
	# Update's the item's sprite.
	update_sprite(id)


func _on_input_event(viewport, event, shape_idx):
	# Signals when the item has been selected and disconnects itself.
	
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		animation.play("select")
		emit_signal("selected", id)
		yield(animation, "animation_finished")
		animation.play("idle")

