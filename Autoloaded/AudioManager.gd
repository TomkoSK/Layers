extends Node

var playingMenuMusic = false#Used in MainMenu.gd
var ambienceTracks = {"prologueScene" : ["Dread.mp3", "Dread"]}
var currentAmbienceTrack = ""
var playingAmbience = false

func setMenuMusicVolume(volume : float, time : float = 0):#Makes the main menu music fade to {volume} level of sound over {time} seconds
	#VOLUME PARAMETER OF THIS FUNCTION IS INDEPENDENT FROM THE VOLUME OF THE MUSIC BUS!!!
	if(volume == 0):
		volume = 0.01
	if(time > 0):
		var tween = self.create_tween()#tweens are used for changing variables smoothly
		tween.tween_property($MenuMusic, "volume_db", linear_to_db(volume), time)
	else:
		$MenuMusic.volume_db = linear_to_db(volume)

func setMenuMusicPlaying(playing : bool, pause : bool = false):
	if(pause):
		$MenuMusic.stream_paused = playing
	else:
		if(playing):
			$MenuMusic.play()
		else:
			$MenuMusic.stop()

func setAmbienceVolume(volume : float, time : float = 0):
	if(volume == 0):
		volume = 0.01
	if(time > 0):
		var tween = self.create_tween()
		tween.tween_property($AmbienceAudio, "volume_db", linear_to_db(volume), time)
	else:
		$AmbienceAudio.volume_db = linear_to_db(volume)

func setAmbiencePlaying(playing : bool, pause : bool = false):
	if(pause):
		$AmbienceAudio.stream_paused = playing
	else:
		if(playing):
			$AmbienceAudio.play()
		else:
			$AmbienceAudio.stop()

func setAmbienceTrack(trackName : String):
	$AmbienceAudio.stream = load("res://Audio/"+ambienceTracks[trackName][0])
	currentAmbienceTrack = ambienceTracks[trackName][1]

func _on_menu_music_finished():
	$MenuMusic.play()#whenever the main menu music finishes it loops again

func _on_ambience_audio_finished():
	$AmbienceAudio.play()#same as the menu music

func _process(_delta):
	playingMenuMusic = $MenuMusic.playing
	playingAmbience = $AmbienceAudio.playing