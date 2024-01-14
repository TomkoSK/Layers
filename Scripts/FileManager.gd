extends Node

var settings_file_name = "user://settings.tres"#Global variable just in case other scripts need to know where the settings file is 
#(changing it will be easier if needed in the future)
var current_save_file : SaveFile = null#The save file object that is currently being played on will be put here
var current_save_file_number : int = 0#The save slot number of the current save file
var playtime_timer

func _ready():
	playtime_timer = Timer.new()
	playtime_timer.wait_time = 1
	playtime_timer.one_shot = false
	playtime_timer.connect("timeout", _on_playtime_timer_timeout)
	self.add_child(playtime_timer)
	playtime_timer.start()#The timer is 1 second long, used for incrementing the player's savefile playtime

func load_settings():#user:// directory is the correct place for saved files that change
	if ResourceLoader.exists(settings_file_name):
		var settings = ResourceLoader.load(settings_file_name)
		if settings is Settings:
			return settings
		else:
			print("[WARNING] Settings file is bad")#NOTE: maybe make this reset the settings or something in the future
			#so that when the settings are invalid it doesn't just stop working for the player forever
	else:
		return Settings.new()

func load_save_file(save_file_number : int):
	if ResourceLoader.exists("res://savefile%s.tres" % save_file_number):#GDscript format string
		var savefile = ResourceLoader.load("res://savefile%s.tres" % save_file_number)
		#NOTE: DO NOT FORGET TO CHANGE THIS TO user://savefile when exporting the project this is for DEBUGGING PURPOSES
		if savefile is SaveFile:
			return savefile
		else:
			print("[WARNING] Save file is bad")#NOTE: same thing as the line 11 comment
	else:
		return SaveFile.new()

func set_active_save_file(save_file_number : int):
	if(save_file_number == 0):#If save file is set to 0, it means that no save file is currently being used
		current_save_file = null
		current_save_file_number = 0
	else:#Otherwise just set it to whatever number is passed
		current_save_file = load_save_file(save_file_number)
		current_save_file_number = save_file_number

func _on_playtime_timer_timeout():#Increases the playtime of the active save file by 1 every second
	if(current_save_file_number != 0):
		current_save_file.playtime += 1

func save():#Saves the current save file data
	current_save_file.last_scene = get_tree().current_scene.scene_file_path
	ResourceSaver.save(current_save_file, "res://savefile%s.tres" % current_save_file_number)
