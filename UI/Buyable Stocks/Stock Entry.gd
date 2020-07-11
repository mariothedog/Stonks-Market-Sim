extends MarginContainer

onready var logo = get_node("HBoxContainer/Logo")
onready var company_name = get_node("HBoxContainer/Name")
onready var price = get_node("HBoxContainer/Price")

var price_value = 0

func _process(_delta):
	price.text = "$" + str(price_value)
