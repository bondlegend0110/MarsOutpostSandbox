extends Node

signal data_updated(system_name, data)

func _process(delta):
	var data = get_system_data()
	emit_signal("data_updated", "water_system", data)

func get_system_data():
	return {"status": "operational", "water_output": 100}
