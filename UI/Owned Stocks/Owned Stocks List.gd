extends MarginContainer

var money = 0

onready var money_label = get_node("MarginContainer/HBoxContainer/Money")

func _process(_delta):
	money_label.text = "$" + str(money)
