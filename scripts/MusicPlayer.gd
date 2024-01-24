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
	# Create two new busses, one for each track, send both to the original
	# Bus a for old tracks fading out, at position i
	# Bus b for new tracks fading in, at position j 
	AudioServer.add_bus()
	var i = AudioServer.bus_count-1
	AudioServer.add_bus()
	var j = i + 1
	var original_bus = currently_playing.get_bus()
	var bus_a = AudioServer.get_bus_name(i)
	var bus_b = AudioServer.get_bus_name(j)
	var track_a = currently_playing
	var track_b = audio_ids[id]
	AudioServer.set_bus_send(i, original_bus)
	AudioServer.set_bus_send(j, original_bus)
	
	# Add amps to new busses, to be used for fading
	# Amp B will start at -30db
	var amp_a = AudioEffectAmplify.new()
	var amp_b = AudioEffectAmplify.new()
	amp_b.set_volume_db(-30)
	AudioServer.add_bus_effect(i, amp_a)
	AudioServer.add_bus_effect(j, amp_b)
	
	# Direct tracks to their respective busses
	# and start track B
	track_a.set_bus(bus_a)
	track_b.set_bus(bus_b)
	track_b.play()
	
	# Set up the tween
	var fade_tween = create_tween()
	fade_tween.tween_property(amp_a, "volume_db", -30, duration)
	fade_tween.parallel().tween_property(amp_b, "volume_db", 0, duration)
	
	# Add the tween callbacks (what happens after they stop)
	# Stop track a, assign track b to the current track, remove the temp busses 
	var cleanup = func ():
		track_a.stop()
		currently_playing = track_b
		AudioServer.set_bus_mute(i, true)
		AudioServer.remove_bus(i)
		AudioServer.remove_bus(j)
	fade_tween.tween_callback(cleanup)


