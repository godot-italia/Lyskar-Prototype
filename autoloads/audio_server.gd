extends Node

# flags
var fade_out_menu_audio = false
var fade_out_time       = 0.5
var fading_out_delta    = 0


func _ready():
	set_process(false)
	set_volume_for_each_GUI_element()


#---------------------- Global Bus --------------------------------
func mute_music(val):
	AudioServer.set_bus_mute(4,val)

#---------------------- GUI sounds --------------------------------
func set_volume_for_each_GUI_element():
	$menu/ambient.volume_db      = -18
	$menu/music.volume_db        = 0
	$menu/button_hover.volume_db = -12
	$menu/button_press.volume_db = 0

func play_menu_audio_background():
	$menu/ambient.play()
	$menu/music.play()

func fade_out_menu_audio():
	fade_out_menu_audio = true
	set_process(true)
	fading_out_delta = fade_out_time

func stop_all_menu_audio():
	for audio_node in $menu.get_children():
		audio_node.stop()
	set_volume_for_each_GUI_element()

func play_hover_button(): $menu/button_hover.play()
func play_press_button(): $menu/button_press.play()


#---------------------- Arena sounds -------------------------
func play_arena_sounds():
	$arena/stadium.play()

func stop_all_arena_audio():
	for audio_node in $arena.get_children():
		audio_node.stop()

#----------------------- process -----------------------------

func _process(d):
	if fade_out_menu_audio:
		fading_out_delta -= d
		if fading_out_delta <= 0:
			stop_all_menu_audio()
			set_process(false)
			#set bus volume 1 ("Menu") back to 0 db
			AudioServer.set_bus_volume_db(1,0)
		else:
			var volume = lerp( 0, -72, fading_out_delta/fade_out_time )
			#set bus volume 1 ("Menu") to "volume" db
			AudioServer.set_bus_volume_db(1,volume)
	
