class_name MainMenu
extends Node2D

# Variables
export var first_night: PackedScene
var flyers: Array


func _ready():
	# Signal connections.
	$StartButton.connect("selected", self, "_on_StartButton_selected")
	
	$PressureTire.connect("finished", self, "_on_PressureTire_finished")
	
	$GasTank.connect("gas_finished", self, "_on_GasTank_gas_finished")


func _on_StartButton_selected(id):
	# Starts filling the tires with air.
	
	if Global.tutorial_done:
		start_game()
	else:
		yield($StartButton/Animation, "animation_finished")
		$PressureTire.new_air_pump(0, 1, 0, 0)


func _on_PressureTire_finished(id):
	#Starts filling the tank with gas.
	
	yield($PressureTire/Animation, "animation_finished")
	$GasTank.new_tank(0, 2, 0, 0)
	

func _on_GasTank_gas_finished(gas):
	# Begins night as car drives away.
	
	yield($GasTank/Animation, "animation_finished")
	$Animation.play("exit")


func start_game():
	# Starts the night as the car drives away.
	
	Global.tutorial_done = true
	get_tree().change_scene_to(first_night)

