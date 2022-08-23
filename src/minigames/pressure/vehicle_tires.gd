class_name VehicleTires
extends Node2D

# Signal
signal item_selected(id)

# Variables
onready var animation = $Animation
onready var vehicle = $Vehicle
onready var tires = [$TireUL, $TireUR, $TireDL, $TireDR]


func _ready():
	# Signal connections.
	for node in tires:
		var tire: ItemSelect = node
		tire.connect("selected", self, "_on_Tire_selected")


func _on_Tire_selected(id):
	# Sends a signal with the selected object's id and plays the exit animation.
	
	for node in tires:
		var tire: ItemSelect = node
		if tire.id == id:
			tires.erase(tire)
			break
	
	animation.play("exit")
	
	yield(animation, "animation_finished")
	emit_signal("item_selected", id)


func next_tire():
	# Lets the rest of the tires to be pickable.
	
	animation.play("enter")
	
	yield(animation, "animation_finished")
	for node in tires:
		var tire: ItemSelect = node
		tire.input_pickable = true


func new_tire(car_id):
	# Restarts all settings and accomodates for the next client.
	
	tires = [$TireUL, $TireUR, $TireDL, $TireDR]
	
	# Updates the vehicle and tires' sprites.
	for node in tires:
		var tire: ItemSelect = node
		tire.update_sprite(car_id)
	
	vehicle.frame = car_id
	
	next_tire()

