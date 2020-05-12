#====================#
# billboard_label.gd #
#====================#

extends Spatial

var text = ""
var duration = 1.5 #seconds
var pos : Vector3

func _ready():
	translation = pos
	$viewport/ciccio/label.text = text
	$anim.playback_speed = 1/duration
#	var viewport_for_panel = ViewportTexture.new()
#	viewport_for_panel.viewport_path = $viewport.get_path()
#	$panel.get_surface_material(0).set("albedo_texture", viewport_for_panel)
	$anim.play("fade_out")
