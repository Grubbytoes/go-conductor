extends Node

@onready var AUDIO_IDS = {
	"tangerineK2": $tangerineK2
}

# Plays the node of the given id
func play(id):
	AUDIO_IDS[id].play()
