extends CanvasLayer

export(String, FILE,"*.json") var dialogue_file

var dialogues = []
var current = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

func play():
	dialogues = load_dialogue()
	#$Panel/Name.text = dialogues[0]["name"]
	current = -1
	next_line()
	#if Input.is_action_just_pressed("dialogue"):
	#	next_line()
	
func _input(event):
	# press space to go to the next dialogue
	if event.is_action_pressed("dialogue"):
		next_line()
		
	
func next_line():
	current += 1
	$Panel/Name.text = dialogues[current]["name"]
	$Panel/Message.text = dialogues[current]["text"]
	if current >= len(dialogues):
		return

func load_dialogue():
	var file = File.new()
	if file.file_exists(dialogue_file):
		file.open(dialogue_file, file.READ)
		return parse_json(file.get_as_text())


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
