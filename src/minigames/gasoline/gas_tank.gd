class_name GasTank
extends Node2D

# Signals
signal gas_updated(gallons)
signal gas_finished(gallons)

# Variables
onready var hose_tank = $HoseTank
onready var car_tank = $CarTank
onready var car_top = $CarTop

func _ready():
	# Signal connections.
	hose_tank.connect("used", self, "_on_HoseTank_used")
	hose_tank.connect("finished", self, "_on_HoseTank_finished")


func _on_HoseTank_used(id, progress):
	# Signals the updated amount of gas.
	
	emit_signal("gas_updated", progress)


func _on_HoseTank_finished(gallons):
	# Signals the final usage of the hose and plays the exit animation.
	
	$Animation.play("exit")
	emit_signal("gas_finished", gallons)


func new_tank(hose_id, gas_goal, gas_current, car_id):
	# Restarts all settings and accomodates for a new tank.
	
	hose_tank.progress = gas_current
	hose_tank.id = hose_id
	hose_tank.goal = gas_goal
	hose_tank.update_sprite(hose_id)
	car_tank.frame = car_id
	car_top.frame = car_id
	
	$Animation.play("enter")

