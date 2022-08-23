class_name FlyerCounter
extends Node2D

# Variables
var job = 0
var car = 0
var vacations = 0


func load_flyers(flyers: Array):
	# Loads the amount of flyers.
	
	vacations = flyers[0]
	$Vacations.text = str(vacations)
	
	car = flyers[1]
	$Car.text = str(car)
	
	job = flyers[2]
	$Job.text = str(job)


func delete_flyer(flyer_id):
	# Reduces the amount of a flyer type.
	
	if flyer_id == 0:
		vacations -= 1
		$Vacations.text = str(vacations)
	if flyer_id == 1:
		car -= 1
		$Car.text = str(car)
	if flyer_id == 2:
		job -= 1
		$Job.text = str(job)

