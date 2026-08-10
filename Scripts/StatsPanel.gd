extends Panel

onready var hpLabel = $StatsContainer/HP
onready var mpLabel = $StatsContainer/MP
onready var apLabel = $StatsContainer/AP


func _on_PlayerStats_ap_changed(value, maxValue):
	apLabel.text = "AP\n"+str(value) + "/" + str(maxValue)


func _on_PlayerStats_mp_changed(value, maxValue):
	mpLabel.text = "MP\n"+str(value) + "/" + str(maxValue)


func _on_PlayerStats_hp_changed(value, maxValue):
	print(value)
	hpLabel.text = "HP\n"+str(value) + "/" + str(maxValue)
