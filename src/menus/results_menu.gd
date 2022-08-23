class_name ResultsMenu
extends Node2D

# Variables
const GAS_PRICE = 2
const FLYER_PRICE = 140

var flyers_sold = 0
var flyers_gain = 0
var gas_used = 0.0
var gas_cost = 0.0
var remainder = 0.0


func _ready():
	# Signal connections.
	$BackButton.connect("selected", self, "_on_BackButton_selected")
	
	# Displays information.
	
	flyers_sold = Global.advertisement_sold
	gas_used = Global.gas_used
	
	flyers_gain = flyers_sold * FLYER_PRICE
	gas_cost = gas_used * GAS_PRICE
	
	remainder = flyers_gain - gas_cost
	
	$FlyersSold.text = "(" + str(flyers_sold) + ") $" + str(flyers_gain)
	$Gas.text = "- $" + str(gas_cost)
	$Result.text = "$" + str(remainder)


func _on_BackButton_selected(id):
	# Returns to the main menu.
	
	yield($BackButton/Animation, "animation_finished")
	get_tree().change_scene("res://src/menus/main_menu.tscn")

