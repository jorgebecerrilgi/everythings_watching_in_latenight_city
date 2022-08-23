class_name GasPump
extends Node2D

# Signal
signal item_selected(id)


func _ready():
	# Signal connections.
	$HoseNormal.connect("selected", self, "_on_Hose_selected")
	$HosePremium.connect("selected", self, "_on_Hose_selected")


func _on_Hose_selected(id):
	# Sends a signal with the selected object's id and plays the exit animation.
	
	$HoseNormal.input_pickable = false
	$HosePremium.input_pickable = false
	$Animation.play("exit")
	yield($Animation, "animation_finished")
	emit_signal("item_selected", id)


func new_pump():
	# Restarts all settings and accomodates for the next client.
	
	$Animation.play("enter")

