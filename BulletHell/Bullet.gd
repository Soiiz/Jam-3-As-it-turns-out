extends Node2D

# credits to https://www.youtube.com/watch?v=miEi6IWvVgw&ab_channel=yokcos

var velocity = Vector2()
var duration = 10
var letter = "" setget set_letter

func _ready():
	connect("body_entered", self, "on_body_entered")

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
		print("Hit")
		body.take_damage(1)
		queue_free()
