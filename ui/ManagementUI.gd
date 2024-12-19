extends Control

func _on_data_updated(system_name, data):
	if system_name == "tractor":
		update_tractor_ui(data)
	elif system_name == "mine":
		update_mine_ui(data)
	elif system_name == "water_system":
		update_water_system_ui(data)
	elif system_name == "food_processor":
		update_food_processor_ui(data)
	elif system_name == "armory":
		update_armory_ui(data)
	elif system_name == "well":
		update_well_ui(data)

func update_tractor_ui(data):
	# Update UI elements for tractor
	pass

func update_mine_ui(data):
	# Update UI elements for mine
	pass

func update_water_system_ui(data):
	# Update UI elements for water system
	pass

func update_food_processor_ui(data):
	# Update UI elements for food processor
	pass

func update_armory_ui(data):
	# Update UI elements for armory
	pass

func update_well_ui(data):
	# Update UI elements for well
	pass
