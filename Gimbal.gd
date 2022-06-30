extends Spatial

onready var camera = $InnerGimbal/Camera
onready var innergimbal = $InnerGimbal

export var max_zoom = 3.0
export var min_zoom = 0.5
export var zoom_speed = 0.08
var zoom = 1.5

export var speed = 0.3
export var drag_speed = 0.005
export var acceleration = 0.08
export var mouse_sensitivity = 0.005

var move = Vector3()


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = true

func _input(event):
	if Input.is_action_pressed("rotate_cam"):
		if event is InputEventMouseMotion:
			if event.relative.x != 0:
				rotate_object_local(Vector3.UP, -event.relative.x * mouse_sensitivity)
			if event.relative.y != 0:
				var y_rotation = clamp(-event.relative.y, -30, 30)
				innergimbal.rotate_object_local(Vector3.RIGHT, y_rotation * mouse_sensitivity)
	if Input.is_action_pressed("move_cam"):
		if event is InputEventMouseMotion:
			move.x -= event.relative.x * drag_speed
			move.z -= event.relative.y * drag_speed
	
	if event.is_action_pressed("zoom_in"):
		zoom -= zoom_speed
	if event.is_action_pressed("zoom_out"):
		zoom += zoom_speed
	zoom = clamp(zoom, min_zoom, max_zoom)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#zoom camera
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)
	#clamp rotation
	innergimbal.rotation.x = clamp(innergimbal.rotation.x, -1.1, 0.3)
	#move camera
	move_cam(delta)

func move_cam(delta):
	#get inputs
	if Input.is_action_pressed("move_forward"):
		move.z = lerp(move.z,-speed, acceleration)
	elif Input.is_action_pressed("move_backward"):
		move.z = lerp(move.z,speed, acceleration)
	else:
		move.z = lerp(move.z, 0, acceleration)
	if Input.is_action_pressed("move_left"):
		move.x = lerp(move.x,-speed, acceleration)
	elif Input.is_action_pressed("move_right"):
		move.x = lerp(move.x,speed, acceleration)
	else:
		move.x = lerp(move.x, 0, acceleration)
	
	#move camera
	translation += move.rotated(Vector3.UP,self.rotation.y) * zoom
	translation.x = clamp(translation.x,-20,20)
	translation.z = clamp(translation.z,-20,20)



