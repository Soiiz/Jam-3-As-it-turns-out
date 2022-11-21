extends Node

const bullet = preload("res://BulletHell/Bullet.tscn")

export (int) var speed = 100

# timer for bullet fire rate
var timer = 0
var delay = .2
#timer for word spawn rate
var word_timer = 0
var word_delay = 2

# queue for words includes letter position and direction
# [[[letter, position, direction], [letter, position, direction]...]]
var queue = [] 
var word_list = ["Cringe", "Gamer", "Nerd", "Hanzo Main", "Smelly"] # list of words


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot(letter: String, speed : int, position : Vector2, direction: float):
	var new_bullet = bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	new_bullet.letter = letter
	get_parent().add_child(new_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	# shoots bullets from queue if timer is up
	if timer <= 0 and queue.size() > 0:
		for word in queue:
			if(word[0][0] != " "):
				shoot(word[0][0], speed, word[0][1], word[0][2])
			word.pop_front()
			if(word.size() == 0):
				queue.erase(word)
		timer = delay
	else:
		timer -= delta

	# runs functions to add bullets to queue
	if word_timer <= 0:
		pan_shot()
		word_timer = word_delay
	else:
		word_timer -= delta

# adds to queue a word thats shot in a panning motion
func pan_shot(): 
	var word_queue = []   
	var word = word_list[randi() % word_list.size()]
	var position = Vector2(clamp(randi() % 1024, 100, 1024 - 100), 0)
	var rotation_amount = 60
	var direction = 90
	var pan_direction = randi() % 2
	direction += (-1 if pan_direction else 1) * rotation_amount / 2
	for letter in word:
		word_queue.append([letter, position, direction])
		direction += (1 if pan_direction else -1) * rotation_amount / (word.length() - 1)
	queue.append(word_queue)

