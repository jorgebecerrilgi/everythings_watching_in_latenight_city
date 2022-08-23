class_name Pressure
extends Node2D

# Signals
signal finished(correct_amount)

# Variables
var initial_pressures = []
var requested_pressure = 0.0
var requested_tires = []
var requested_amount = 0
var correct_amount = 0
var car_id = 0

onready var tire = $Tire
onready var vehicle_tires = $VehicleTires
onready var meter_pressure = $MeterPressure


func _ready():
	# Signal connections.
	vehicle_tires.connect("item_selected", self, "_on_vehicle_tires_item_selected")
	tire.connect("pressure_updated", self, "_on_tire_pressure_updated")
	tire.connect("finished", self, "_on_tire_finished")


func _on_vehicle_tires_item_selected(id):
	# Transitions between the vehicle and tire minigame.
	
	tire.new_air_pump(id, requested_pressure, initial_pressures[id], car_id)
	meter_pressure.appear()
	meter_pressure.update_indicator_pos(initial_pressures[id])


func _on_tire_pressure_updated(seconds):
	# Updates the pressure meter.
	
	meter_pressure.update_indicator_pos(seconds)


func _on_tire_finished(tire_id):
	# Signals it's finished when the amount of tires requested has been used.
	
	meter_pressure.disappear()
	requested_amount -= 1
	
	if requested_tires.has(tire_id):
		correct_amount += 1
	
	if requested_amount == 0:
		emit_signal("finished", correct_amount)
	else:
		vehicle_tires.next_tire()


func new_order(initial_pressures_, requested_tires_, requested_pressure_, car_id_):
	# Places a new air pressure order.
	
	initial_pressures = initial_pressures_
	requested_pressure = requested_pressure_
	requested_tires = requested_tires_
	requested_amount = requested_tires.size()
	correct_amount = 0
	car_id = car_id_
	
	vehicle_tires.new_tire(car_id)

