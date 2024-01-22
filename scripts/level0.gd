extends Node2D


func _ready():
	MusicPlayer.play("tangerine-I")


func _on_button_pressed():
	MusicPlayer.fade_to("spinning out", 4)
