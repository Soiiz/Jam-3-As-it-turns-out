extends Node


var globalDrawings := {"test" : [[Vector2(100,100),Color.red]]}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_drawing(name : String, drawing : Array): #drawing must be of specific type
	var error = drawing.duplicate(true)
	if error != OK:
		print("Error saving drawing")
		return
	globalDrawings[name] = drawing
