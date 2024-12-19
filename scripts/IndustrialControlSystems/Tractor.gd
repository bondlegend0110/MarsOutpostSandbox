extends Node

signal data_updated(system_name, data)

func _process(delta):
	var data = get_system_data()
	emit_signal("data_updated", "tractor", data)

func get_system_data():
	return {"status": "operational", "crops_planted": 100}
