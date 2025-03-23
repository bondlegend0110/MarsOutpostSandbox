extends CharacterBody3D

@export var SPEED: float = 10.0
@export var JUMP_VELOCITY: float = 4.5
@export var enable_gravity = true

@onready var _player_visual: Node3D = %"team_fortress_2_-_medic_robot"
@onready var _player_pcam: Node3D = %PlayerPhantomCamera3D
@onready var _profile_pcam: PhantomCamera3D

@export var mouse_sensitivity: float = 1

#@export var min_pitch: float = 0
#@export var max_pitch: float = 50

#@export var min_yaw: float = 0
#@export var max_yaw: float = 360

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var movement_enabled: bool = true

var _physics_body_trans_last: Transform3D
var _physics_body_trans_current: Transform3D

var pitch_radians: float = 0.0
var yaw_radians: float = 0.0

func _ready() -> void:
	_profile_pcam = owner.get_node("./Profile View/%ProfilePhantomCamera3D")
	
	# If we're in third-person, capture the mouse initially.
	if _player_pcam.get_follow_mode() == _player_pcam.FollowMode.THIRD_PERSON:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	_physics_body_trans_last = _physics_body_trans_current
	_physics_body_trans_current = global_transform

	if enable_gravity and not is_on_floor():
		velocity.y -= gravity * delta

	if not movement_enabled:
		return

	# Get the input direction
	var input_dir: Vector2 = Input.get_vector("move_forward", "move_backward", "move_left", "move_right")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		# Input directions in x/z are swapped to match movement with typical WASD arrangement
		var move_dir: Vector3 = Vector3.ZERO
		move_dir.x = direction.z
		move_dir.z = direction.x

		# Rotate by the camera's current Y rotation
		move_dir = move_dir.rotated(Vector3.UP, _player_pcam.rotation.y).normalized()
		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	# -- REMOVED the velocity-based rotation of _player_visual --
	# This line used to rotate the character based on velocity:
	# if velocity.length() > 0.2:
	#     var look_direction: Vector2 = Vector2(velocity.z, velocity.x)
	#     _player_visual.rotation.y = look_direction.angle()

	move_and_slide()

func _process(_delta: float) -> void:
	# Interpolate the visual for smoother motion
	_player_visual.global_transform = _physics_body_trans_last.interpolate_with(
		_physics_body_trans_current,
		Engine.get_physics_interpolation_fraction()
	)

func _unhandled_input(event: InputEvent) -> void:
	# 1) Press ESC to release the mouse.
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		# Example: Toggle camera priority with "F".
		if event.keycode == KEY_F:
			if _player_pcam.get_priority() > _profile_pcam.get_priority():
				_profile_pcam.set_priority(5)
			else:
				_profile_pcam.set_priority(0)

	# 2) If we click while mouse is free, capture it again.
	if event is InputEventMouseButton and event.pressed:
		# Left-click re-captures the mouse if it's free
		if event.button_index == MOUSE_BUTTON_LEFT and Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		# Optional zoom in/out logic (mouse wheel)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var pcam_offset: Vector3 = _player_pcam.get_follow_offset()
			pcam_offset.y -= 1
			pcam_offset.z -= 1
			_player_pcam.set_follow_offset(pcam_offset)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			var pcam_offset2: Vector3 = _player_pcam.get_follow_offset()
			pcam_offset2.y += 1
			pcam_offset2.z += 1
			_player_pcam.set_follow_offset(pcam_offset2)

	# 3) Rotate the player node on mouse motion (instead of rotating the camera).
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		# Convert mouse delta to degrees
		var delta_x_deg = -event.relative.x * mouse_sensitivity
		var delta_y_deg = -event.relative.y * mouse_sensitivity

		# Convert degrees to radians
		var delta_x_rad = deg_to_rad(delta_x_deg)
		var delta_y_rad = deg_to_rad(delta_y_deg)

		# Update pitch (X-axis). Convert min_pitch and max_pitch to radians.
		var old_pitch = pitch_radians
		pitch_radians += delta_y_rad
		#pitch_radians = clamp(pitch_radians, deg_to_rad(min_pitch), deg_to_rad(max_pitch))

		# Rotate _player_visual around local X axis by the delta
		var pitch_delta = pitch_radians - old_pitch
		_player_visual.rotate_x(pitch_delta)

		# Update yaw (Y-axis). 
		var old_yaw = yaw_radians
		yaw_radians += delta_x_rad

		# Option A: Wrap to 360
		yaw_radians = fposmod(yaw_radians, TAU) # TAU is 2π

		# Option B: Hard clamp between min_yaw..max_yaw
		# yaw_radians = clamp(yaw_radians, deg_to_rad(min_yaw), deg_to_rad(max_yaw))
		
		# Rotate _player_visual around local Y axis by the delta
		var yaw_delta = yaw_radians - old_yaw
		_player_visual.rotate_y(yaw_delta)
