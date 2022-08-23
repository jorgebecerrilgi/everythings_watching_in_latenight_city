class_name Intro
extends Sprite


func load_flyers(flyers: Array):
	# Loads all flyer amounts.
	
	$Vacations.text = str(flyers[0])
	$Car.text = str(flyers[1])
	$Job.text = str(flyers[2])
	
	$Animation.play("exit")

