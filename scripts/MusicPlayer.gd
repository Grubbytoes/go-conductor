extends Node

var audio_ids = {}

func _ready():
	for child in get_children():
		audio_ids[child.name] = child

# Plays the node of the given id
func play(id):
	audio_ids[id].play()
