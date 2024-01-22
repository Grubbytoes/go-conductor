extends Node

var audio_ids = {}
var is_playing = false
var currently_playing = null

func _ready():
	for child in get_children():
		audio_ids[child.name] = child

# Plays the node of the given id
func play(id):
	is_playing = true
	var track = audio_ids[id]
	track.play()
	currently_playing = track

func stop(id):
	var track = audio_ids[id]
	track.stop()

func fade_to(id, duration):
	# Create a new bus which is sent to the original
	# Set the new tracks to the original 
	AudioServer.add_bus()
	var i = AudioServer.bus_count-1
	var original_bus = currently_playing.get_bus()
	var new_bus = AudioServer.get_bus_name(AudioServer.bus_count-1)
	var original_track = currently_playing
	var new_track = audio_ids[id]
	AudioServer.set_bus_send(i, original_bus)
	
	# Start the new track
	currently_playing.set_bus(new_bus)
	
	# Add an amp effect to fade out the new bus
	var amp = AudioEffectAmplify.new()
	AudioServer.add_bus_effect(i, amp)
	
	# begin tweening 
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(amp, "volume_db", -30, duration).as_relative()
	fade_tween.tween_callback(original_track.stop)
	fade_tween.tween_callback(AudioServer.set_bus_mute.bind(i, true)).set_delay(1)
	fade_tween.tween_callback(AudioServer.remove_bus.bind(i)).set_delay(1)
	fade_tween.play()
	


