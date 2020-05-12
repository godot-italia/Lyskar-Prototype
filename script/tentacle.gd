#=====================================#
#                                     #
#            tentacle.gd              #
#                                     #
#=====================================#

extends Spatial


onready var ik = preload("res://script/ik.gd").new()
export(NodePath) var node_to_reach_path
var node_to_reach

export(int)   var tot_segments   = 10
export(float) var segment_length = 1

var points = [] #Vector3 array
var reach_point
var sections = []

func _ready():
	set_physics_process(false)
	
	yield(get_tree(),"idle_frame")
	
	if !node_to_reach_path:
		print("Tentacle %s: node to be reached PATH not set"%name)
		return
	
	node_to_reach = get_node(node_to_reach_path)
	
	if node_to_reach:
		set_tentacle_points()
		set_physics_process(true)


func set_tentacle_points():
	
	#--- points array for IK script
	for i in range(tot_segments):
		points.append( Vector3( 0, segment_length * float(i%2), 0 ) )
	ik.set_nodes(points)
	
	#--- make mesh unique so that it doesn't override the others
	$section.mesh = $section.mesh.duplicate()
	
	#--- adjust section to length
	$section.mesh.radius = segment_length/1.0       # sphere shape
	$section.mesh.height = $section.mesh.radius*2 # sphere shape
#	$section.mesh.radius = segment_length/4       # capsule shape
#	$section.mesh.mid_height = segment_length/2   # capsule shape
	
	#--- create sections for each pair of points
	sections.append($section)
	for i in range(1,points.size()-1):
		var new_sec = $section.duplicate()
		add_child(new_sec)
		sections.append(new_sec)
	

func _physics_process(delta):
	#--- reach_node origin to local coordinates
	reach_point = node_to_reach.global_transform.origin - global_transform.origin
	
	#--- calculate new points for the curve and apply to the path
	# IK returns ONE calculated interaction at each pass to adjust
	# the position of the points in the space
	points = ik.reach_target(reach_point)
	
	for i in range(points.size()-1):
		sections[i].transform.origin = points[i] + (points[i+1] - points[i])/2
		
		# set segment rotation TODO
#		sections[i].rotate = Vector3(1,0,0).direction_to(points[i+1] - points[i])
#		sections[i].transform = sections[i].transform.looking_at(points[i] + points[i+1],Vector3(0,0,1))
#		sections[i].rotation.y = points[i].angle_to(points[i+1])
#		sections[i].rotation.z = points[i].angle_to(points[i+1])
		
