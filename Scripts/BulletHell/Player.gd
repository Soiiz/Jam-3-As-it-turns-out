extends KinematicBody2D

class_name ControllableCharacter

export (int) var speed = 200
export (int) var hp = 100 # subject to implementation change as values need to be passed around
export (int) var shield = 10 # subject to value change
export var win = false;
signal health_changed(hp)
signal game_over(win)
var inputAllowed := true setget setInputAllowed, getInputAllowed;

var velocity = Vector2()

onready var sprite = $Sprite
onready var shieldObj = $Shield
onready var tweenObj = $Tween

# delay for when player can take damage again
export (float) var invun_frames = 10.0
var invun_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	emit_signal("health_changed", hp)
	pass # Replace with function body.

func get_input():
	velocity = Vector2()
	# dont update velocity if input is not allowed
	if not inputAllowed:
		return

	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func tweenTo(_position : Vector2, time : float) -> void:
	tweenObj.interpolate_property(self, "position",self.position, _position, time,Tween.TRANS_LINEAR,Tween.EASE_IN);
	tweenObj.start();
	pass

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	# keep object on screen
	position.x = clamp(position.x, sprite.texture.get_width() * sprite.scale.x / 2, get_viewport_rect().size.x - sprite.texture.get_width() * sprite.scale.x / 2)
	position.y = clamp(position.y, sprite.texture.get_height() * sprite.scale.y / 2, get_viewport_rect().size.y - sprite.texture.get_height() * sprite.scale.y / 2)
	# rotate sprite based on velocity direction
	if velocity.length() > 0:
		rotation = velocity.angle() + PI*1/2
		
	# shows and hides shield based on shield hp (probably a better way to do this)
	if shield > 0:
		shieldObj.show()
	else:
		shieldObj.hide()
		
	if invun_timer > 0:
		invun_timer -= delta

func take_damage(damage):
	# skip damage if player still invun
	if invun_timer > 0:
		return
	# set timer if damage is taken
	invun_timer = invun_frames
	# deal damage to shield/hp
	if shield > damage:
		shield -= damage
	elif shield > 0:
		damage -= shield
		shield = 0
	else:
		hp -= damage
		emit_signal("health_changed", hp)
	if (hp <= 0):
		print("game over")
		win = false
		emit_signal("game_over", win)
		
	print("player hp: ", hp)
	print("player shield: ", shield)
func setInputAllowed(value : bool):
	inputAllowed = value;

func getInputAllowed():
	return inputAllowed

func _on_SampleScene_heal_health(heal):
	if(hp >= 100):
		print("cant heal")
	else:
		hp += heal
		emit_signal("health_changed", hp)
