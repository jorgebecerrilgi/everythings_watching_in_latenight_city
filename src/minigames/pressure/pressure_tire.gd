class_name PressureTire
extends Node2D

# Signals
signal pressure_updated(psi)
signal finished(tire_id)

# Variables
onready var air_pump = $AirPump
onready var tire = $Tire
var current_tire_id = 0


func _ready():
	# Signal connections.
	air_pump.connect("used", self, "_on_air_pump_used")
	air_pump.connect("finished", self, "_on_air_pump_finished")


func _on_air_pump_used(id, progress):
	# Signals the updated amount of pressure.
	
	emit_signal("pressure_updated", progress)


func _on_air_pump_finished(psi):
	# Signals the final usage of the air pump and plays the exit animation.
	
	$Animation.play("exit")
	emit_signal("finished", current_tire_id)


func new_air_pump(tire_id, pressure_goal, pressure_current, car_id):
	# Restarts all settings and accomodates for a new tank.
	
	current_tire_id = tire_id
	air_pump.progress = pressure_current
	air_pump.goal = pressure_goal
	
	# Changes the tire sprite.
	tire.frame = car_id
	
	$Animation.play("enter")

