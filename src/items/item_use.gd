class_name ItemUse
extends Item

# Signals
signal used(id, progress)
signal finished(progress)

# Variables
var goal = 0.0
var id = 0
var progress = 0.0
onready var timer_progress: Timer = $TimerProgress


func _ready():
	timer_progress.connect("timeout", self, "_on_TimerProgress_timeout")


func _on_TimerProgress_timeout():
	# Advances the item's usage progress.
	
	progress += 0.25
	emit_signal("used", id, progress)


func check_goal():
	# Signals if the item has stopped being used and has reached its progress goal.
	
	if progress >= goal:
		input_pickable = false
		emit_signal("finished", progress)

