extends Node

func _ready():
	# Load management UI
	var management_ui = load("res://ui/ManagementUI.tscn").instance()
	add_child(management_ui)

	# Load terrain and solar panels
	var terrain = load("res://scenes/Terrain.tscn").instance()
	add_child(terrain)
	
	var solar_panels = load("res://scenes/SolarPanels.tscn").instance()
	add_child(solar_panels)

	# Load crop and system instances
	var crops = ["Potato", "SweetPotato", "Legume", "Quinoa", "LeafyGreens", "Tomato", "Pepper", "Strawberry", "Mushroom"]
	for crop in crops:
		var crop_instance = load("res://scenes/Crops/" + crop + ".tscn").instance()
		add_child(crop_instance)
	
	var systems = ["Tractor", "Mine", "WaterSystem", "FoodProcessor", "Armory", "Well"]
	for system in systems:
		var system_instance = load("res://scenes/IndustrialControlSystems/" + system + ".tscn").instance()
		add_child(system_instance)
		system_instance.connect("data_updated", management_ui, "_on_data_updated")
