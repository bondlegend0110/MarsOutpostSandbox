extends Node3D

@onready var _water_system: Node3D = $WaterSystem
@onready var _rain_0: GPUParticles3D = $WaterSystem/Rain0
@onready var _rain_1: GPUParticles3D = $WaterSystem/Rain1

# Determines whether we rotate the water system.
var pump_control: bool = false  
# Determines whether to show/hide rain nodes.
var valve_control: bool = false  

var forward := 1

func _ready():
	pass # Any initialization code

func _process(delta):
	# 1) Only rotate if pump_control is TRUE.
	if pump_control:
		if _water_system.get_global_rotation_degrees().y < -170 and forward == 1:
			forward = -1
		elif _water_system.get_global_rotation_degrees().y < -1 and forward == -1:
			forward = 1
		_water_system.rotate_y(deg_to_rad(1) * forward)
		# Debug print
		print("Water system rotation (pump on): ", _water_system.get_global_rotation_degrees().y)

	# 2) Show/hide the Rain nodes based on valve_control
	#    If valve_control is TRUE => Visible. If FALSE => Hidden.
	_rain_0.emitting = valve_control
	_rain_1.emitting = valve_control


# Called from Main.gd to update the pump state
func set_pump_state(state: bool) -> void:
	pump_control = state

# Called from Main.gd to update the valve state
func set_valve_state(state: bool) -> void:
	valve_control = state
