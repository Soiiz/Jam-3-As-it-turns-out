extends KinematicBody2D

class_name ControllableCharacter

# Declare member variables here. Examples:
# var a: int = 2
# https://www.youtube.com/watch?v=BeSJgUTLmk0&ab_channel=HeartBeast reference for making script

var moveBy : Vector2 = Vector2(0,0);
var inputAllowed := true setget setInputAllowed, getInputAllowed;
var ableToBeHit = true

onready var myTween : Tween = get_node("Tween");
export var maxSpeed := 100;
export var acceleration := 20;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func tweenTo(_position : Vector2, time : float) -> void:
	myTween.interpolate_property(self, "position",self.position, _position, time,Tween.TRANS_LINEAR,Tween.EASE_IN);
	myTween.start();
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if (!inputAllowed):
		return;
	var axis = get_input_axis();
	if axis == Vector2.ZERO:
		apply_friction(acceleration * delta);
	else:
		apply_movement(axis * acceleration * delta);
	moveBy = move_and_slide(moveBy, Vector2.UP)

func get_input_axis() -> Vector2:
	var to_return : Vector2 = Vector2.ZERO;
	to_return.x =  int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"));
	to_return.y =  int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"));
	to_return = to_return.normalized();
	return to_return;

func apply_friction(amount) -> void:
	if moveBy.length() > amount:
		moveBy -= moveBy.normalized() * amount;
	else:
		moveBy = Vector2.ZERO;
		
func apply_movement(amount)-> void:
	moveBy += amount;
	moveBy = moveBy.clamped(maxSpeed);
	
func setInputAllowed(value : bool):
	inputAllowed = value;
	
func getInputAllowed():
	return inputAllowed

func take_damage(damage : int):
	print("taken " + String(damage) + " amount of dmg")
