extends Node

var playingMenuMusic = false#Used in MainMenu.gd
var playingAmbience = false

func startMenuMusic(volume : float, time : float):#Makes the main menu music fade in from 0 to {volume} level of sound over {time} seconds
	$MenuMusic.play()
	var tween = self.create_tween()#tweens are used for changing variables smoothly
	tween.tween_method(setMusicBus, linear_to_db(0.01), linear_to_db(volume), time)

func stopMenuMusic(time : float):#Smoothly drops the main menu music volume to 0
	var tween = self.create_tween()
	tween.tween_method(setMusicBus, AudioServer.get_bus_volume_db(1), linear_to_db(0.01), time)
	tween.tween_callback($MenuMusic.stop)#Only stops the music AFTER the volume goes down to 0

func startAmbience(volume : float, time : float):
	$AmbienceAudio.play()
	var tween = self.create_tween()
	tween.tween_method(setVolumeBus, linear_to_db(0.01), linear_to_db(volume), time)

func stopAmbience(time : float):#Smoothly drops the main menu music volume to 0
	var tween = self.create_tween()
	tween.tween_method(setVolumeBus, AudioServer.get_bus_volume_db(2), linear_to_db(0.01), time)
	tween.tween_callback($AmbienceAudio.stop)

func setMusicBus(db):
	AudioServer.set_bus_volume_db(1, db)

func setVolumeBus(db):
	AudioServer.set_bus_volume_db(2, db)

func _on_menu_music_finished():
	$MenuMusic.play()#whenever the main menu music finishes it loops again

func _on_ambience_audio_finished():
	$AmbienceAudio.play()#same as the menu music

func _process(_delta):
	playingMenuMusic = $MenuMusic.playing
	playingAmbience = $AmbienceAudio.playing