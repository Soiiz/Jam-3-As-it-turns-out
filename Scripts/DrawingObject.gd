extends Node2D

export var width = 400
export var height = 200

var currentColor: Color = Color.red;

var mySpots := [];
onready var myLine : Line2D = get_node("Line2D");


# Called when the node enters the scene tree for the first time.
func _ready():
	myLine.add_point(Vector2(-width,-height));
	myLine.add_point(Vector2(width,-height));
	myLine.add_point(Vector2(width,height));
	myLine.add_point(Vector2(-width,height));
	myLine.add_point(Vector2(-width,-height - myLine.width/2));
	pass # Replace with function body.
	
func _process(delta: float) -> void:
	if (Input.is_action_pressed("ui_mouse")):
		var temp = get_local_mouse_position()
		if (abs(temp.x) < width and abs(temp.y) < height):
			mySpots.append([get_local_mouse_position(),currentColor]);
			update();

func load_drawing(name : String):
	if Global.globalDrawings.has(name):
		mySpots.clear();
		mySpots = Global.globalDrawings[name].duplicate();
		update();

func _draw() -> void:
	for spot in mySpots:
		draw_circle(spot[0],4,spot[1]);
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_ColorPicker_color_changed(color: Color) -> void:
	currentColor = color;
	pass # Replace with function body.
