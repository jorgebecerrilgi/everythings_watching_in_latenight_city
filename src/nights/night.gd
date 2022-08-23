class_name Night
extends Node2D

# Variables
const GAS_MAX = 80
const GAS_MIN = 10
const EMPTY_GAS = 20

const PRESSURE_MAX = 20
const PRESSURE_MIN = 5
const EMPTY_PRESSURE = 5

export var flyers = [0, 0, 0]
export var next_menu: PackedScene

var client_id = 0
var client_data = {
	"gasoline" : {
		"id" : 0,
		"goal" : 0.75
	},
	"pressure" : {
		"id" : [0, 1, 2, 3],
	},
	"advertisement" : [0, 1, 2],
	"dialogue" : ["", ""]
}
var satisfaction = 10
var tires_requested = 1
var gas_id_requested = 0
var ads_requested = []
var ads_sold = 0
var minigame_done = false
var is_midnight = false

onready var gasoline = $Gasoline
onready var pressure = $Pressure
onready var dialogue_box = $DialogueBox
onready var advertisement = $Advertisement
onready var timer = $Timer
onready var client = $Client
onready var flyer_counter = $FlyerCounter
onready var animation = $Animation


func _ready():
	# Signal connections.
	gasoline.connect("finished", self, "_on_gasoline_finished")
	
	pressure.connect("finished", self, "_on_pressure_finished")
	
	advertisement.connect("flyer_selected", self, "_on_advertisement_flyer_selected")
	advertisement.connect("finished", self, "_on_advertisement_finished")
	
	timer.connect("timeout", self, "_on_timer_timeout")
	
	$Clock.connect("finished", self, "_on_Clock_finished")
	
	randomize()
	
	# Chooses the amount of flyers the player has.
	var flyer_seed = randi() % 3
	if flyer_seed == 0:
		flyers = [3, 1, 2]
	elif flyer_seed == 1:
		flyers = [2, 2, 2]
	elif flyer_seed == 2:
		flyers = [1, 2, 3]
	
	# Loads flyers amount to intro screen and hud.
	$Intro.load_flyers(flyers)
	flyer_counter.load_flyers(flyers)
	
	yield($Intro/Animation, "animation_finished")
	next_client()


func _on_pressure_finished(fixed_tires):
	# Reduces satisfaction level for every missing tire.
	
	satisfaction -= tires_requested - fixed_tires
	
	if tires_requested - fixed_tires != 0:
		client.reduce_satisfaction()
	
	if minigame_done:
		load_advertisement()
	else:
		minigame_done = true


func _on_gasoline_finished(used_gas_id, final_gas):
	# Reduces satisfaction level if used gas is incorrect.
	
	if gas_id_requested != used_gas_id:
		satisfaction -= 2
		client.reduce_satisfaction()
	
	if minigame_done:
		load_advertisement()
	else:
		minigame_done = true


func _on_advertisement_flyer_selected(flyer_id):
	# Reduces the flyer type amount, and checks if the client buys something.
	
	flyers[flyer_id] -= 1
	flyer_counter.delete_flyer(flyer_id)
	sell_advertisement(flyer_id)


func _on_advertisement_finished():
	# Transitions between current and next client.
	
	timer.stop()
	dialogue_box.stop_dialogue()
	client.done()
	
	# Ends the night or waits for the next client.
	yield(client.animation, "animation_finished")
	if is_midnight:
		end_night()
	else:
		yield(get_tree().create_timer(10), "timeout")
		next_client()


func _on_timer_timeout():
	# Reduces satisfaction level with the passage of time.
	
	satisfaction -= 1


func _on_Clock_finished():
	# Marks the end of the shift for the night.
	
	is_midnight = true


func next_client():
	# Prepares the next client's information.
	
	satisfaction = 10
	
	var client_seed = randi() % 2
	
	if client_id == 0:
		if client_seed == 0:
			client_data = {
				"gasoline" : {
					"id" : 0,
					"goal" : 0.75
				},
				"pressure" : {
					"id" : []
				},
				"advertisement" : [0, 2],
				"dialogue" : ["God, finally a spot.",
				"Just right there, I was gonna be left stranded.",
				"Fill it with the red juice.",
				"But not fully, only three quarters, please.",
				"",
				"I swear they're gonna kill me someday.",
				"10 hour ride? Let's give him the empty one.",
				"I'm quitting after this, that's for sure. No more stress.",
				"He's gonna be the stupid one, not us, they said.",
				"",
				"Are you guys hiring?",
				"Just wondering.",
				"",
				"You really think you've seen worst, then bam! Higher-ups",
				"You know how it can be.",
				"We're not really that far away, if you think about it.",
				"Us both with a little boot taste in the tip of our mouths.",
				"But not anymore! No.",
				"",
				"You really take your time don't you?"]
			}
		elif client_seed == 1:
			client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 0.75
				},
				"pressure" : {
					"id" : []
				},
				"advertisement" : [1, 2],
				"dialogue" : ["Heya, what about some drink for this lady?",
				"Who am I kidding? This thing is more like a granny.",
				"Just fill it with the grey one.",
				"Not like cheap's gonna kill her more than she already is.",
				"Oh, and just three quarters. This woman doesn't take more.",
				"Sober like her man.",
				"Both not by choice.",
				"",
				"Whatcha say, honey?",
				"You like that? Well, take it as our anniversary gift.",
				"Cause you ain't getting more gifts any time soon, huhey.",
				"Also not by choice.",
				"",
				"Wow man.",
				"No telling, but I don't feel this is going well.",
				"The fights. Oh, you haven't seen anything like those.",
				"Always the money, like it is THAT important.",
				"",
				"Sorry, honey.",
				"Yeah, I didn't know you were, sorry."]
			}
	elif client_id == 1:
		if client_seed == 0:
			client_data = {
				"gasoline" : {
					"id" : 0,
					"goal" : 1
				},
				"pressure" : {
					"id" : []
				},
				"advertisement" : [1],
				"dialogue" : ["Nighty, honey. Nighty.",
				"My tank's a little empty, fill it all for me, yes?",
				"Oh, yes, the red one.",
				"Thank you, honey. Thank you.",
				"My child waits for me at home, I can't make him wait.",
				"Not this time, honey. No.",
				"",
				"Look up for me, honey.",
				"Look up and tell me this night isn't-",
				"just especial.",
				"But theres no time to watch, honey. No.",
				"Time's precious, dear.",
				"I need to get home fast for my child. He's missing me.",
				"He's always missing me.",
				"I've been gone for too long, but not my fault, dear.",
				"Not my fault. Never my fault.",
				"I'm always dissapointing him.",
				"",
				"I hope this thing can get me to him in time.",
				"At least this time, yes."]
			}
		elif client_seed == 1:
			client_data = {
				"gasoline" : {
					"id" : 0,
					"goal" : 0.75
				},
				"pressure" : {
					"id" : []
				},
				"advertisement" : [0],
				"dialogue" : ["It's not often that I come by here.",
				"Three quarters, red. Cash, I got plenty.",
				"Not to show off. Just telling how it is.",
				"That's why today is a not so often day.",
				"I finally realised it: it's enough.",
				"No more, it's enough.",
				"I ended it, I can go back to them now.",
				"Enjoy them, while I can.",
				"All of this, it can come back.",
				"But not time. I realised it.",
				"I realised it, today.",
				"In this not so often day.",
				"Finally want to give them some time.",
				"Why did it took me so long to realise it?",
				"",
				"Sorry to bore you if I did.",
				"Of course I did.",
				"I just haven't been able to rest.",
				"Not entirely."]
			}
	elif client_id == 2:
		client_data = {
			"gasoline" : {
				"id" : 0,
				"goal" : 0.5
			},
			"pressure" : {
				"id" : [0, 1]
			},
			"advertisement" : [],
			"dialogue" : ["I'll take half of red.",
			"And don't forget to check my front tires.",
			"",
			"",
			"I'm curious.",
			"This spot is never open.",
			"But tonight, it shines bright.",
			"Just on the outsides of the city.",
			"",
			"This really reminds me of my mother's saying.",
			"Luck remains the same. Luck for one is unluck for another.",
			"Lucky me, unlucky you.",
			"",
			"I went off again, didn't I?",
			"I was-",
			"Just curious.",
			"Good night."]
		}
	elif client_id == 3:
		if client_seed == 0:
			client_data = {
				"gasoline" : {
					"id" : 0,
					"goal" : 0.5
				},
				"pressure" : {
					"id" : [0, 1, 2, 3]
				},
				"advertisement" : [0],
				"dialogue" : ["Welcome, dear.",
				"This night is just- Yes, half tank red.",
				"And don't worry, son, about my-",
				"For free? Check them all, then! Check all the tires.",
				"These are not times to waste those opportunities.",
				"Soon they leave.",
				"And you look around.",
				"And you're lonely",
				"",
				"God do I need a- I'm sorry.",
				"I just came back from a long ride in this car.",
				"I start talking nonsense.",
				"",
				"You look so young, son.",
				"Good night."]
			}
		elif client_seed == 1:
			client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 1
				},
				"pressure" : {
					"id" : [2, 3]
				},
				"advertisement" : [1, 2],
				"dialogue" : ["This thing and the back tires. Do me the favor.",
				"What you do for your city and how they pay you.",
				"I used to be what they all needed.",
				"I had it all, then I have only this.",
				"It also needs cheap juice, 'till it drips.",
				"I really had him in my fist.",
				"I never gave up, not me.",
				"Now I have him in my trunk, let's say.",
				"For the metaphor.",
				"They thought they lost me, but now I'll show them what's being lost.",
				"",
				"This night, my guy.",
				"It's just so refreshing.",
				"Soon it will be another day, and it'll be a new me.",
				"New everything.",
				"I needed that."]
			}
	elif client_id == 4:
		if client_seed == 0:
			client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 0.75
				},
				"pressure" : {
					"id" : [0, 2]
				},
				"advertisement" : [2],
				"dialogue" : ["My left tires almost gave up on me.",
				"Help me out, man.",
				"I swear we always almost die.",
				"Like man, it's not uncommon anymore.",
				"He'll take three quarters, of the grey one.",
				"Man power, he calls it.",
				"But he still breaks down each time we leave.",
				"But I tell ya, not uncommon anymore.",
				"It is just too difficult to take him out these days.",
				"Not the risk, oh no, I tell you it's like a ride.",
				"But take him out for what?",
				"I need an excuse, a reason.",
				"Not even tonight, I just took him out cause-",
				"Well, just look at the night. It's different.",
				"",
				"You're really taking your time with my pal, man.",
				"",
				"Man, why am I jealous?",
				"Sorry, dude."]
			}
		elif client_seed == 1:
			client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 1
				},
				"pressure" : {
					"id" : [0, 1]
				},
				"advertisement" : [0, 1],
				"dialogue" : ["Where is the fun in this city?",
				"Full red, and check the front tires.",
				"I'm going lose it.",
				"They really promised me fun and fortune.",
				"Luxuries and everything.",
				"And tell me I'm wrong, but I see none of it.",
				"Nada, nothing.",
				"These people really make you buy anything, and you fall for it.",
				"They're experts of course.",
				"'Luxuries', yes darling, of course.",
				"I'm such fool, God.",
				"Now what can I do in this place.",
				"",
				"At least the view is not so bad.",
				"I'll give them that."]
			}
	elif client_id == 5:
		client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 1
				},
				"pressure" : {
					"id" : [1, 3]
				},
				"advertisement" : [],
				"dialogue" : ["Night, boy.",
				"How 'bout you make it full. Cheap one.",
				"And check my right tires, boy.",
				"This place is a blessing, right?",
				"I can see it in your grin.",
				"",
				"I'm not like the rest.",
				"I can see right through you.",
				"This city never sleeps.",
				"You won't, either.",
				"",
				"You won't last long.",
				"Night, boy."]
			}
	elif client_id == 6:
		if client_seed == 0:
			client_data = {
				"gasoline" : {
					"id" : 0,
					"goal" : 0.75
				},
				"pressure" : {
					"id" : [1, 2, 3]
				},
				"advertisement" : [1],
				"dialogue" : ["No wonder the city's streets are empty.",
				"No gas in miles and only one worker! HAH.",
				"Don't waste more time, fill me with the red one.",
				"And just three quarters, fast.",
				"People always messing with your time, thank god you don't complain.",
				"And I need my back tires filled, too.",
				"Always the lost ones complaining, too, HAH.",
				"Some of us trying to use our time correctly, and-",
				"Well, look at them! Wasting both of our times, HAH.",
				"Very laughable.",
				"Do me a favor, check the front right tire, too.",
				"",
				"Did we not agree to be fast?",
				"Well, I did add another instruction not so long ago.",
				"Fair enough, take a little more.",
				"No gas in miles, no faster way to travel, and then one worker!",
				"One painfully slow worker! HAH.",
				"",
				"Least I can do is give you a sweet welcome.",
				"'Cause you came here to stay-",
				"This is nightmare for the flesh.",
				"So good luck staying awake, HAH.",
				"Welcome to Latenight City."]
			}
		elif client_seed == 1:
			client_data = {
				"gasoline" : {
					"id" : 1,
					"goal" : 1
				},
				"pressure" : {
					"id" : [0, 1]
				},
				"advertisement" : [0, 2],
				"dialogue" : ["Greetings, you.",
				"Full, with the cheap one. No worries.",
				"No worries in the world, at all.",
				"Except for those tires in the front, check them, actually.",
				"But apart from those, no worries at all.",
				"How good it feels to be free of responsability.",
				"",
				"But, you wouldn't know friend, would you?",
				"Looking at you I can see it.",
				"But who cares, because you're here-",
				"AT LATENIGHT CITY!",
				"",
				"Who am I kidding. It's horrible, having nothing to do.",
				"I feel like a failure. I need to come back home with something.",
				"Anything. Or I'm gonna die of boredom.",
				"At least the night seems like it's-",
				"Calling?",
				"Wow, boredom really messes with your head, doesn't it?",
				"I'll be going, friend.",
				"Thanks for listening.",
				"And welcome, human boy.",
				"Welcome to Latenight City."]
			}
	elif client_id == 7:
		end_night()
		return
	
	client_id += 1
	load_client()


func load_client():
	# Shows client to the player and begins minigames.
	
	var car_id = client.new_client()
	yield(client.animation, "animation_finished")
	
	load_gas(client_data["gasoline"], car_id)
	load_pressure(client_data["pressure"], car_id)
	dialogue_box.new_dialogue(client_data["dialogue"])
	timer.start()


func load_gas(data, car_id):
	# Loads the gasoline minigame.
	
	var requested_gas = GAS_MAX * data["goal"]
	var initial_gas = rand_range(GAS_MIN, requested_gas - EMPTY_GAS)
	gas_id_requested = data["id"]
	
	gasoline.new_order(gas_id_requested, requested_gas, initial_gas, car_id)


func load_pressure(data, car_id):
	# Loads the air pressure minigame.
	
	if data["id"].empty():
		minigame_done = true
		return
	
	var initial_pressures: Array
	tires_requested = data["id"].size()
	
	for i in range(4):
		randomize()
		initial_pressures.append(rand_range(PRESSURE_MIN, PRESSURE_MAX - EMPTY_PRESSURE))
	
	pressure.new_order(initial_pressures, data["id"], PRESSURE_MAX, car_id)


func load_advertisement():
	# Loads the advertisement minigame.
	
	ads_requested = client_data["advertisement"]
	minigame_done = false
	
	advertisement.start(flyers)


func sell_advertisement(flyer_id):
	# Checks and writes if the client buys the advertisement.
	
	if ads_requested.has(flyer_id):
		if satisfaction >= 8:
			ads_sold += 1
			satisfaction -= 1
			return
		elif satisfaction >= 6:
			if randi() % 2 == 0:
				ads_sold += 1
				return
			satisfaction -= 1
	satisfaction -= 1
	client.reduce_satisfaction()
	client.throw_away_flyer(flyer_id)


func end_night():
	# Finishes the night.
	
	Global.advertisement_sold = ads_sold
	Global.gas_used = gasoline.total_gas
	animation.play("exit")
	
	yield(animation, "animation_finished")
	get_tree().change_scene_to(next_menu)

