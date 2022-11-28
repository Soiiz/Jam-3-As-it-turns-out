extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var active = false
var hp = 10 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !active:
		self.hide()
	else:
		self.show()
		
	
func take_damage(damage):
	hp -= damage
	if hp == 0:
		queue_free()
