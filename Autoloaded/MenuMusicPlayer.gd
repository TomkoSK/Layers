extends Node

var fadingIn = false
var fadingOut = false
var volumeIncrement = 0
var currentVolume = 0
var changeTime = 1
var playingMenuMusic = false#Used in MainMenu.gd

func fadeIn(volume : float, time : float):#Makes the main menu music fade in from 0 to {volume} level of sound over {time} seconds
	currentVolume = 0#current volume is changed because _physics_process() uses the variable
	AudioServer.set_bus_volume_db(1, 0)#first sets the volume to 0
	$AudioStreamPlayer.play()
	volumeIncrement = volume*100#This sets how much the volume should be incremented by, its multiplied by 100 because in the 
	#_physics_process() func its multiplied by delta, resulting in a very small number. when it wasnt multiplied by 100 godot 
	#didnt register such a small number
	changeTime = time#used in _process()
	fadingIn = true
	var t = Timer.new()#waits for {time} seconds
	t.set_wait_time(changeTime)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	fadingIn = false
	currentVolume = volumeIncrement#sets the volume to the exact volume given at the end in case there's some small inaccuracy
	AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))#currentVolume gets divided by 100 because it was multiplied at the start

func fadeOut(time : float):#Smoothly drops the main menu music volume to 0
	#basically the same as the function above
	currentVolume = db_to_linear(AudioServer.get_bus_volume_db(1))*100
	volumeIncrement = currentVolume
	changeTime = time
	fadingOut = true
	var t = Timer.new()
	t.set_wait_time(changeTime)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	fadingOut = false
	currentVolume = 0#sets the current volume to 0 at the end instead
	AudioServer.set_bus_volume_db(1, 0)
	$AudioStreamPlayer.stop()

func _physics_process(delta):
	if(fadingIn):
		currentVolume += volumeIncrement/changeTime*delta#increments the current volume if fading in
		AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))#divided by a 100 because it was multiplied at the start
		#1 is the index of the music audio bus
	if(fadingOut):
		currentVolume -= volumeIncrement/changeTime*delta#decrements the current volume if fading out
		AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))
	playingMenuMusic = $AudioStreamPlayer.playing

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()#whenever the main menu music finishes it loops again
