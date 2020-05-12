#=======================#
#        MANAGER        #
#  User and game pref   #
#        mng.gd         #
#=======================#
extends Node

#========= SAVE/LOAD =======
#--- config_files
var data_dir  = "user://"#str(OS.get_system_dir(0))
var data_filename = "user_preferences.pol"
var data_path = str(data_dir,data_filename)

#--- user_pref
# some vars from ntw.gd will be saved/loaded here
var fullscreen = false setget _fullscreen_toggled
var gui_sfx_on = true  setget _gui_sfx_toggled # Audio bus 1
var sfx_on     = true  setget _sfx_toggled     # Audio bus 2
var ambient_on = true  setget _ambient_toggled # Audio bus 3
var music_on   = true  setget _music_toggled   # Audio bus 4


#================================== INIT =======================================

func _ready():
	load_initial_settings()
	apply_setting()

func apply_setting():
	OS.window_fullscreen = fullscreen
	AudioServer.set_bus_mute(1,gui_sfx_on)
	AudioServer.set_bus_mute(2,sfx_on)
	AudioServer.set_bus_mute(3,ambient_on)
	AudioServer.set_bus_mute(4,music_on)

#================================ LOAD/SAVE ====================================

func load_initial_settings():
	var dir = Directory.new()
	#--- check if file and folder exist
	if dir.open(data_dir) != OK:
		create_default_config()
	elif not Directory.new().file_exists(data_path):
		create_default_config()
	#--- finally load user preferences and ntw var
	else:
		var file_config = ConfigFile.new()
		file_config.load(data_path)
		ntw.developer_name = file_config.get_value("user_pref", "developer_name", "" )
		fullscreen = file_config.get_value("user_pref", "fullscreen", fullscreen )
		gui_sfx_on = file_config.get_value("user_pref", "gui_sfx_on", gui_sfx_on )
		sfx_on     = file_config.get_value("user_pref", "sfx_on", sfx_on )
		ambient_on = file_config.get_value("user_pref", "ambient_on", ambient_on )
		music_on   = file_config.get_value("user_pref", "music_on", music_on )


func create_default_config():
	var dir = Directory.new()
	if dir.open(data_dir) != OK:
		var err_dir = dir.make_dir_recursive(data_dir)
		if err_dir != OK:
			return
	#--------- default values
	save_data()

func save_data():
	var file_config = ConfigFile.new()
	file_config.set_value("user_pref", "developer_name", ntw.developer_name)
	file_config.set_value("user_pref", "fullscreen", fullscreen)
	file_config.set_value("user_pref", "gui_sfx_on", gui_sfx_on)
	file_config.set_value("user_pref", "sfx_on", sfx_on)
	file_config.set_value("user_pref", "ambient_on", ambient_on)
	file_config.set_value("user_pref", "music_on", music_on)
	
	file_config.save(data_path)


#================================== SETGET =====================================

func _fullscreen_toggled(val):
	fullscreen = val ; save_data()
func _gui_sfx_toggled(val):
	gui_sfx_on = val ; save_data()
func _sfx_toggled(val):
	sfx_on = val ; save_data()
func _ambient_toggled(val):
	ambient_on = val ; save_data()
func _music_toggled(val):
	music_on = val ; save_data()


