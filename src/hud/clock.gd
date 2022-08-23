class_name Clock
extends Node2D

# Signals
signal finished

# Variables
var decimal = 0
var unit = 0

onready var timer_seconds = $TimerSeconds
onready var units = $Units


func _ready():
	# Signal connections.
	timer_seconds.connect("timeout", self, "_on_timer_seconds_timeout")


func _on_timer_seconds_timeout():
	# Advances the clock by a second.
	
	unit += 1
	
	if unit == 10:
		# Ten minutes pass.
		unit = 0
		decimal += 1
		
		if decimal == 6:
			# The night ends.
			$Hours.text = "24:00"
			$Decimals.text = ""
			units.text = ""
			timer_seconds.stop()
			emit_signal("finished")
			return
	
	$Decimals.text = str(decimal)
	units.text = str(unit)
	

