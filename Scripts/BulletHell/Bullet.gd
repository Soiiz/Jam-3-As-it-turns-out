extends Node2D

# credits to https://www.youtube.com/watch?v=miEi6IWvVgw&ab_channel=yokcos

var velocity = Vector2()
var duration = 20
var letter = "" setget set_letter
var damage = 10

func _ready():
	var error = connect("body_entered", self, "on_body_entered")
	if error != OK:
		print("Error connecting signal: ", error)

func _process(delta):
	position += velocity * delta

	duration -= delta
	if duration <= 0:
		queue_free()

func set_letter(new_letter):
	letter = new_letter
	get_node("Label").text = letter

func on_body_entered(body):
	if body.name == "Player":
		body.take_damage(damage)
		queue_free()
