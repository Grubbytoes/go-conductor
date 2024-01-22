extends Node2D


@onready var conductor = $Conductor


func _on_button_pressed():
	conductor.cue_track("bass")
	conductor.cue_track("synthMotif")
	conductor.play()
