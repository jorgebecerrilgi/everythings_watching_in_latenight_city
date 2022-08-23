class_name Client
extends Node2D

# Variables
var trash = preload("res://src/minigames/advertisement/trash.tscn")
var negative_satisfaction = preload("res://src/hud/satisfaction_indicator.tscn")
var car_type = 0
var color_id = 0

onready var animation = $Animation


func new_client() -> int:
	# Randomizes the car sprite arriving.
	
	randomize()
	car_type = randi() % 2
	color_id = randi() % 6
	update_sprite(car_type, color_id)
	
	animation.play("enter")
	
	return color_id


func update_sprite(car, color):
	# Changes the car sprites, depending on the receiving arguments.
	
	$Car.frame_coords = Vector2(color, car)
	$StationCar.frame_coords = Vector2(color, car)


func done():
	# Plays the exit animation.
	
	animation.play("exit")


func throw_away_flyer(id):
	# Instances a flyer trash.
	
	var trash_ = trash.instance()
	add_child(trash_)
	trash_.start(id)


func reduce_satisfaction():
	# Instances a negative satisfaction indicator.
	
	var negative_satisfaction_ = negative_satisfaction.instance()
	add_child(negative_satisfaction_)
	negative_satisfaction_.start()

