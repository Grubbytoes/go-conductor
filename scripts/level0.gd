extends Node2D


func _ready():
	MusicPlayer.switch_to("tangerine-I")
	MusicPlayer.play()


func _on_button_pressed():
	MusicPlayer.switch_to("spinning out")
