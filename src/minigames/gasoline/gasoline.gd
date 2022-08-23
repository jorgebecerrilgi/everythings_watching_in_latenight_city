class_name Gasoline
extends Node2D

# Signals
signal finished(used_gas_id, final_gas)

# Variables
var gas_id = 0
var initial_gas = 0.0
var requested_gas = 0.0
var total_gas = 0.0
var used_gas_id = 0
var car_id = 0

onready var pump = $Pump
onready var tank = $Tank
onready var meter_fuel = $MeterFuel

func _ready():
	# Signal connections.
	pump.connect("item_selected", self, "_on_pump_item_selected")
	
	tank.connect("gas_updated", self, "_on_tank_gas_updated")
	tank.connect("gas_finished", self, "_on_tank_gas_finished")


func _on_pump_item_selected(id):
	# Transitions between the pump and the tank minigame.
	
	tank.new_tank(id, requested_gas, initial_gas, car_id)
	meter_fuel.appear()
	meter_fuel.update_indicator_pos(initial_gas)
	
	used_gas_id = id


func _on_tank_gas_updated(seconds):
	# Updates the fuel meter.
	
	meter_fuel.update_indicator_pos(seconds)


func _on_tank_gas_finished(final_gas):
	# Keeps track of the amount of gas used.
	
	total_gas += final_gas - initial_gas
	meter_fuel.disappear()
	emit_signal("finished", used_gas_id, final_gas)


func new_order(gas_id_, requested_gas_, initial_gas_, car_id_):
	# Places a new gas-filling order.
	
	gas_id = gas_id_
	requested_gas = requested_gas_
	initial_gas = initial_gas_
	car_id = car_id_
	
	pump.new_pump()

