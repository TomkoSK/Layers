extends Node

var playingMenuMusic = false#Used in MainMenu.gd

func fadeIn(volume : float, time : float):#Makes the main menu music fade in from 0 to {volume} level of sound over {time} seconds
	$AudioStreamPlayer.play()
	var tween = self.create_tween()#tweens are used for changing variables smoothly
	tween.tween_method(setMusicBus, linear_to_db(0.01), linear_to_db(volume), time)

func fadeOut(time : float):#Smoothly drops the main menu music volume to 0
	var tween = self.create_tween()
	tween.tween_method(setMusicBus, AudioServer.get_bus_volume_db(1), linear_to_db(0.01), time)
	tween.tween_callback($AudioStreamPlayer.stop)#Only stops the music AFTER the volume goes down to 0

func setMusicBus(db):
	AudioServer.set_bus_volume_db(1, db)

func _process(delta):
	playingMenuMusic = $AudioStreamPlayer.playing

func _on_audio_stream_player_finished():
	$AudioStreamPlayer.play()#whenever the main menu music finishes it loops again