extends MarginContainer

onready var stock_entries = get_node("MarginContainer/ScrollContainer/Stock Entries")

var stock_entry_scene = preload("res://UI/Buyable Stocks/Stock Entry.tscn")

func _ready():
	for stock in StockManager.stocks_list:
		var stock_entry = stock_entry_scene.instance()
		stock_entries.add_child(stock_entry)
		stock_entry.company_name.text = stock.company_name
		stock_entry.price_value = 100
