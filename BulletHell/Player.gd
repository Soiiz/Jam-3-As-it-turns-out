extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var hp = 100 # subject to implementation change as values need to be passed around
var shield = 10 # subject to value change
onready var sprite = $Sprite
onready var shieldObj = $Shield
# delay for when player can take damage again
export (float) var invun_frames = 10
var invun_timer = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("right"):
		velocity.x += 1
	if Input.is_action_pressed("left"):
		velocity.x -= 1
	if Input.is_action_pressed("down"):
		velocity.y += 1
	if Input.is_action_pressed("up"):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	# keep object on screen
	position.x = clamp(position.x, sprite.texture.get_width() * sprite.scale.x / 2, get_viewport_rect().size.x - sprite.texture.get_width() * sprite.scale.x / 2)
	position.y = clamp(position.y, sprite.texture.get_height() * sprite.scale.y / 2, get_viewport_rect().size.y - sprite.texture.get_height() * sprite.scale.y / 2)
	# rotate sprite based on velocity direction
	if velocity.length() > 0:
		rotation = velocity.angle() + PI*3/2
		
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
		print("skipped damage")
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
	print("hp: " + str(hp))
	print("shield: " + str(shield))

	

