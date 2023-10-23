extends Node
@export_category("Motion Node")
@export_group("HeadBob State")
@export var enable_headbob : bool = true
@export var enable_stab : bool = true

@export_group("Values")
@export var Amplitude : float = 0.05
@export var Frequency : float = 2.5

@export_group("Nodes")
@export var Camera : Camera3D 
@export var Marker : Marker3D
@export var Player : CharacterBody3D
@export var feet_audio_player : AudioStreamPlayer3D

@export_group("Footstep")
@export var footstep_sounds : Array[AudioStreamWAV]

var time : float = 0.0

func _physics_process(delta):
		
	if enable_headbob:
		if Player.velocity.length() > 0:
			time += delta * Player.velocity.length() * float(Player.is_on_floor())
			Camera.transform.origin = Motion()
			if enable_stab:
				Camera.look_at(Marker.global_position)
		else:
			RestartPosition(delta)
	

func Motion() -> Vector3:
	var Pos = Vector3.ZERO
	Pos.y += sin(time * Frequency) * Amplitude
	Pos.x += cos(time * Frequency / 2) * Amplitude * 2
	return Pos
	
func RestartPosition(delta):
	if Camera.transform.origin == Vector3.ZERO: return
	Camera.transform.origin = Camera.transform.origin.lerp(Vector3.ZERO,10 * delta)
	time = 0.0

func PlayFootStepSound():
	var random_index : int = randi_range(0,footstep_sounds.size() - 1)
	feet_audio_player.stream = footstep_sounds[random_index]
	feet_audio_player.pitch_scale = randf_range(0.8,1.2)
	feet_audio_player.play()
