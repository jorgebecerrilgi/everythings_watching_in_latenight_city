class_name Advertisement
extends Node2D

# Signals
signal flyer_selected(id)
signal finished()

# Variables
onready var flyer_vacation = $FlyerVacation
onready var flyer_car = $FlyerCar
onready var flyer_job = $FlyerJob
onready var animation = $Animation
onready var rope = $Rope
onready var flyers = [flyer_vacation, flyer_car, flyer_job]


func _ready():
	# Signal connections.
	flyer_vacation.connect("selected", self, "_on_item_selected")
	flyer_car.connect("selected", self, "_on_item_selected")
	flyer_job.connect("selected", self, "_on_item_selected")
	
	rope.connect("selected", self, "_on_rope_selected")


func _on_item_selected(flyer_id):
	# Signals the selected flyer.
	
	emit_signal("flyer_selected", flyer_id)


func _on_rope_selected(id):
	# Ends the minigame.
	
	animation.play("exit")
	yield(animation, "animation_finished")
	emit_signal("finished")


func start(flyers_available: Array):
	# Displays all available flyers and lets the user select them.
	
	for id in range(3):
		if flyers_available[id] != 0:
			var flyer: ItemSelect = flyers[id]
			flyer.show()
	
	animation.play("enter")
	
	yield(animation, "animation_finished")
	for item in flyers:
		var flyer: ItemSelect = item
		if flyer.visible:
			flyer.input_pickable = true

