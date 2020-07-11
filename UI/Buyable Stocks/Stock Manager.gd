extends Node

var stocks_list = []

class Stock:
	var company_name
	var headline_category
	func _init(_company_name : String, _headline_category : HeadlineCategories.Headline_Category):
		self.company_name = _company_name
		self.headline_category = _headline_category
		StockManager.stocks_list.append(self)

# Technology
onready var pear = Stock.new("Pear", HeadlineCategories.technology_category)
onready var macrosoft = Stock.new("Macrosoft", HeadlineCategories.technology_category)
onready var samsmug = Stock.new("Samsmug", HeadlineCategories.technology_category)
onready var teslow = Stock.new("Teslow", HeadlineCategories.technology_category)

# Gaming
onready var wintendo = Stock.new("Wintendo", HeadlineCategories.gaming_category)
onready var mt = Stock.new("MT", HeadlineCategories.gaming_category)
onready var game_maniac = Stock.new("Game Maniac", HeadlineCategories.gaming_category)

# Social media
onready var facepalm = Stock.new("Facepalm", HeadlineCategories.social_media_category)
onready var idlegram = Stock.new("Idlegram", HeadlineCategories.social_media_category)
onready var twatter = Stock.new("Twatter", HeadlineCategories.social_media_category)
onready var discrash = Stock.new("Discrash", HeadlineCategories.social_media_category)
onready var itchy = Stock.new("Itchy.me", HeadlineCategories.social_media_category)
onready var youtried = Stock.new("YouTried", HeadlineCategories.social_media_category)
onready var reddat = Stock.new("Reddat", HeadlineCategories.social_media_category)

# Commerce
onready var amazone = Stock.new("Amazone", HeadlineCategories.commerce_category)
onready var wellmart = Stock.new("Wellmart", HeadlineCategories.commerce_category)
onready var ebae = Stock.new("Ebæ", HeadlineCategories.commerce_category)

# Food
onready var moonbucks = Stock.new("Moonbucks", HeadlineCategories.food_category)
onready var ofc = Stock.new("OFC", HeadlineCategories.food_category)
onready var wacdonalds = Stock.new("WacDonalds", HeadlineCategories.food_category)
onready var wesleys = Stock.new("Wesley's", HeadlineCategories.food_category)
onready var bestle = Stock.new("Bestlé", HeadlineCategories.food_category)
onready var cocaine = Stock.new("Coca-ine", HeadlineCategories.food_category)
onready var pepsical = Stock.new("Pepsical", HeadlineCategories.food_category)

# Clothing
onready var mike = Stock.new("Mike", HeadlineCategories.clothing_category)

# Search engine
onready var google = Stock.new("Yoogle", HeadlineCategories.search_engine_category)
onready var wahoo = Stock.new("Wahoo", HeadlineCategories.search_engine_category)

# Entertainment
onready var crustyroll = Stock.new("Crustyroll", HeadlineCategories.entertainment_category)
onready var netflick = Stock.new("Netflick", HeadlineCategories.entertainment_category)
onready var jisney = Stock.new("Jisney", HeadlineCategories.entertainment_category)

# Information
onready var wackypedia = Stock.new("Wackypedia", HeadlineCategories.information_category)
