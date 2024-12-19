extends Node

signal data_updated(system_name, data)

var power_generated = 0

func _process(delta):
	power_generated = calculate_power_generated()
	var data = {"status": "operational", "power_generated": power_generated}
	emit_signal("data_updated", "solar_panels", data)

func calculate_power_generated():
	# Logic to calculate power generated based on conditions like sunlight, panel efficiency, etc.
	return 100  # Example value
