extends Node

const bullet = preload("res://prefabs/BulletHell/Bullet.tscn")

var bullet_speed = 100
var player_speed = 100 setget set_playerSpeed
var shield = 0 setget set_playerShield

#mode of bullet hell
#0: all firing modes
#1: carpet shots
#2: pan shots
#4: targeted shots
export (int) var mode = 0

# timer for bullet fire rate
var timer = 0
export (float) var bullet_delay = .2
#timer for word spawn rate
var word_timer = 0
export (float) var word_delay = 1.5
export (int) var bullet_damage = 10
export (int) var difficulty = 0 setget set_difficulty

var firingEnabled = true;

onready var targetPlayer = $Player
onready var background = $Background
# container for bullets
onready var bullets = $Bullets

# queue for words includes letter position and direction
# [[[letter, position, direction], [letter, position, direction]...]]
var queue = [] 
# words used as bullets
var word_list = ["Cringe", "Gamer", "Nerd", "Hanzo Main", "Smelly", "Baka", 
				"Shorty", "Slow", "Hardheaded", "Jerk", "Dumb", "Loser", 
				"Weeb", "Trash", "Noob", "Lame", "Weak", "Boring", "Stupid",
				"Bully"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func shoot(letter: String, speed : int, position : Vector2, direction: float):
	var new_bullet = bullet.instance()
	new_bullet.velocity = Vector2(speed, 0).rotated(deg2rad(direction))
	new_bullet.position = position
	new_bullet.letter = letter
	new_bullet.damage = bullet_damage
	bullets.add_child(new_bullet)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (!firingEnabled):
		return

	# shoots bullets from queue if timer is up
	if timer <= 0 and queue.size() > 0:
		for word in queue:
			if(word[0][0] != " "):
				shoot(word[0][0], bullet_speed, word[0][1], word[0][2])
			word.pop_front()
			if(word.size() == 0):
				queue.erase(word)
		timer = bullet_delay
	else:
		timer -= delta

	# runs functions to add bullets to queue
	if word_timer <= 0:
		if mode == 0:
			var shot_type = randi() % 3
			if shot_type == 0:
				carpet_shot()
			elif shot_type == 1:
				pan_shot()
			elif shot_type == 2:
				targeted_shot()
		elif mode == 1:
			carpet_shot()
		elif mode == 2:
			pan_shot()
		elif mode == 3:
			targeted_shot()
		else:
			print("Mode not set to a valid number")
		word_timer = word_delay
	else:
		word_timer -= delta

#adds to queue a word thats shot like a carpet bombing
func carpet_shot():
	var word_queue = []
	var word = word_list[randi() % word_list.size()]
	var carpet_direction = randi() % 2
	var movement = clamp(randi() % 500, 200, 500) * (1 if carpet_direction else -1)
	var position = Vector2(clamp(randi() % 1024, 0 if carpet_direction else -(movement), 1024 - (movement if carpet_direction else 0)), 0)
	for letter in word if carpet_direction else reverse_string(word):
		word_queue.append([letter, position, 90])
		position += Vector2(movement / word.length() - 1, 0)
	queue.append(word_queue)

# adds to queue a word thats shot in a panning motion
func pan_shot(): 
	var word_queue = []   
	var word = word_list[randi() % word_list.size()]
	var position = Vector2(clamp(randi() % 1024, 100, 1024 - 100), 0)
	var rotation_amount = 60
	var direction = 90
	var pan_direction = randi() % 2
	direction += (-1 if pan_direction else 1) * rotation_amount / 2
	
	for letter in reverse_string(word) if pan_direction else word:
		word_queue.append([letter, position, direction])
		direction += (1 if pan_direction else -1) * rotation_amount / (word.length() - 1)
	queue.append(word_queue)
	
#instantly fires all the words
# please help there must be a better way to do this using angles
func targeted_shot():
	var word = word_list[randi() % word_list.size()]
	var length = clamp(randi() % 1024, 200, 1024)
	var position = Vector2(randi() % 1024 - length,0)
	var player_position = targetPlayer.position
	var letter_list = []
	var longest_distance = 0
	for letter in word:
		var velocity = player_position - position
		if velocity.length() > longest_distance:
			longest_distance = velocity.length()
		letter_list.append([letter, velocity])
		position += Vector2(length / (word.length() - 1), 0)
	for bullet in letter_list:
		var bullet_vector = bullet[1].normalized() * longest_distance
		shoot(bullet[0], bullet_speed, player_position - bullet_vector, bullet[1].angle() * 180 / PI)
		
		
#reverse string function
#credits: https://www.reddit.com/r/godot/comments/o9owcw/comment/h3ci1by/?utm_source=share&utm_medium=web2x&context=3
func reverse_string(s:String) -> String:
	var r := "" 
	for i in range(s.length()-1, -1, -1):
		r += s[i]
	return r

func hide():
	firingEnabled = false
	for bullet in bullets.get_children():
		bullet.hide()
		bullet.queue_free()
	targetPlayer.hide()
	background.hide()


func show():
	firingEnabled = true
	targetPlayer.show()
	background.show()

func set_difficulty(difficulty: int):
    bullet_speed = 100 + 50 * difficulty
    bullet_delay = 0.5 - 0.05 * difficulty
    if bullet_delay < 0.01:
        bullet_delay = 0.01
    word_delay = 1.2 - 0.1 * difficulty
    if word_delay < 0.01:
        word_delay = 0.01
    bullet_damage = 10 + 2 * difficulty
    if difficulty < 2:
        mode = 1
    elif difficulty < 4:
        mode = 2
    elif difficulty < 5:
        mode = 3
    elif difficulty >= 6:
        mode = 0

func set_playerSpeed(speed: int):
	targetPlayer.speed = speed

func set_playerShield(hp: int):
	targetPlayer.shield = hp
