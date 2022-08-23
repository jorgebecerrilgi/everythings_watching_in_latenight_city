class_name DialogueBox
extends Label

# Variables
var dialogue: Array
var amount: int
var number = 0

onready var timer_next = $TimerNext


func _ready():
	# Signal connections.
	timer_next.connect("timeout", self, "_on_timer_next_timeout")


func _on_timer_next_timeout():
	# Advances to the next dialogue.
	
	number += 1
	
	if number >= amount:
		stop_dialogue()
	else:
		text = dialogue[number]


func new_dialogue(dialogue_):
	# Loads a new dialogue and starts reading through them.
	
	dialogue = dialogue_
	amount = dialogue.size()
	number = 0
	text = dialogue[number]
	timer_next.start()


func stop_dialogue():
	# Stops reading the dialogue.
	
	timer_next.stop()
	text = ""
	dialogue.clear()

