class_name Meter
extends Node2D

# Variables
export var seconds_to_complete = 0
var seconds_per_pixel: float
var seconds = 0.0

onready var indicator = $Indicator
onready var initial_pos = indicator.position.x
onready var start = $Start.position.x
onready var end = $End.position.x

onready var animation = $Animation

func _ready():
	# Calculates the seconds it takes the indicator to move a pixel.
	seconds_per_pixel = seconds_to_complete / (end - start)


func update_indicator_pos(seconds_):
	# Updates the position of the meter indicator.
	
	seconds = seconds_
	indicator.position.x = seconds / seconds_per_pixel + initial_pos
	indicator.position.x = clamp(indicator.position.x, initial_pos, end)


func appear():
	# Appears meter.
	
	animation.play("enter")


func disappear():
	# Disappears meter.
	
	animation.play("exit")

