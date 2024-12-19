extends Node

# Constants for crop growth stages
enum CropStage {
	PLANTED,
	SEEDLING,
	GROWING,
	HARVESTABLE
}

# Variables to track crop state
var current_stage := CropStage.PLANTED
var weeks_grown := 0
var water_consumption := 0.0

func _ready():
	# Initialize crop growth process
	start_growing()

func _process(delta):
	# Update crop growth based on weeks passed
	weeks_grown += 1
	update_crop_growth()

func start_growing():
	current_stage = CropStage.PLANTED
	water_consumption = 0.0  # No water consumption until seedling stage
	# Additional initialization as needed

func update_crop_growth():
	match current_stage:
		CropStage.PLANTED:
			if weeks_grown >= 1:  # Initial planted stage
				current_stage = CropStage.SEEDLING
				water_consumption = 0.3
				# Additional actions for stage transition
				
		CropStage.SEEDLING:
			var growth_time = get_growth_time()
			if weeks_grown >= growth_time:  # Check if crop is ready to grow
				current_stage = CropStage.GROWING
				water_consumption = 0.75
				# Additional actions for stage transition
				
		CropStage.GROWING:
			var maturity_time = get_maturity_time()
			if weeks_grown >= maturity_time:  # Check if crop is ready to harvest
				current_stage = CropStage.HARVESTABLE
				water_consumption = 1.25
				# Additional actions for stage transition

func get_growth_time() -> int:
	match name:
		"Potato":
			return 5
		"SweetPotato":
			return 10
		"Legume":
			return 4
		"Quinoa":
			return 7
		"LeafyGreens":
			return 5
		"Tomato":
			return 5
		default:
			return 0

func get_maturity_time() -> int:
	match name:
		"Potato":
			return 10
		"SweetPotato":
			return 10
		"Legume":
			return 4
		"Quinoa":
			return 5
		"LeafyGreens":
			return 0
		"Tomato":
			return 12
		default:
			return 0
