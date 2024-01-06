extends Node

var fadingIn = false
var fadingOut = false
var volumeIncrement = 0
var currentVolume = 0
var changeTime = 1


func _ready():
	startSmooth(SettingsFile.load_settings().music, 2)# smooths out the music volume to start from 0 to the settings.music value in 2 seconds

func startSmooth(linearVolume, time):
	fadeIn(linearVolume, time)

func start():
	$AudioStreamPlayer.play()

func stopSmooth(time):
	fadeOut(time)

func stop():
	$AudioStreamPlayer.stop()

func fadeIn(volume, time):
	$AudioStreamPlayer.play()
	AudioServer.set_bus_volume_db(1, linear_to_db(0))
	volumeIncrement = volume*100
	changeTime = time
	fadingIn = true
	var t = Timer.new()
	t.set_wait_time(changeTime)
	self.add_child(t)
	t.start()
	await t.timeout
	t.queue_free()
	fadingIn = false
	currentVolume = volumeIncrement
	AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))

func fadeOut(time):
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
	currentVolume = 0
	AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))
	$AudioStreamPlayer.stop()

func _physics_process(delta):
	if(fadingIn):
		currentVolume += volumeIncrement/changeTime*delta
		AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))
	if(fadingOut):
		currentVolume -= volumeIncrement/changeTime*delta
		AudioServer.set_bus_volume_db(1, linear_to_db(currentVolume/100))

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()
