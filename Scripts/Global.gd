extends Node


var globalDrawings := {"test" : [[Vector2(100,100),Color.red]]}
var player
var hp = 100;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func save_drawing(name : String, drawing : Array): #drawing must be of specific type
	drawing.duplicate(true);
	globalDrawings[name] = drawing
