extends MarginContainer

class Headlines:
	var text
	var fill_ins
	var start_min_stock_change
	var start_max_stock_change
	func _init(_text : String,
	_start_min_stock_change : float, _start_max_stock_change : float,
	_fill_ins : Array = []):
		self.text = _text
		self.fill_ins = _fill_ins
		self.start_min_stock_change = _start_min_stock_change
		self.start_max_stock_change = _start_max_stock_change

export (Curve) var primary_length_to_font_size

var company_fill_ins = [
	"Pear",
	"Macrosoft",
	"Samsmug",
	"Teslow",
	"Wintendo",
	"MT",
	"Game Maniac",
	"Facepalm",
	"Idlegram",
	"Twatter",
	"Discrash",
	"Itchy.me",
	"YouTried",
	"Reddat",
	"Amazone",
	"Wellmart",
	"Ebæ",
	"Moonbucks",
	"OFC",
	"WacDonalds",
	"Wesley's",
	"Bestlé",
	"Coca-ine",
	"Pepsical",
	"Mike",
	"Yoogle",
	"Wahoo",
	"Crustyroll",
	"Netflick",
	"Frisney",
	"Wackypedia"
]

var specific_person_name_fill_ins = [
	"obama", "trump", "elon musk",
	"mark zuckerberg", "jeff bezos", "Mr. Bean",
	"Pewdiepie", "Ninja", "Abraham Lincoln"
]

var person_name_fill_ins = []

var ceo_fill_ins = []

var positive_event_continuous_fill_ins = [
	"saving a kitten", "saving a dog", "donating to charity",
	"helping a homeless man", "signing armistice", "curing cancer",
	"donating blood"
]

var positive_event_fill_ins = [
	"save a kitten", "save a dog", "donate to charity",
	"helped a homeless man", "sign armistice", "cure cancer",
	"donate blood"
]

var negative_event_fill_ins = [
	"murder", "human trafficking", "commit mass genocide",
	"being mean", "bullying", "nuclear bomb deployment",
	"calling names", "step down", "terminate vaccine development"
]

var death_reason_fill_ins = [
	"covid", "overeating", "dehydration",
	"hypothermia", "hyperthermia", "flu",
	"sleeping too much", "too much sleep", "talking too much",
	"choking"
]

var device_fill_ins = [
	"phone", "car", "bike",
	"mouse", "pen", "tablet",
	"burger", "toilet"
]

var number_fill_ins = [
	"1", "2", "3", "4", "5", "6", "7", "8"
]

var game_name_fill_ins = [
	"Mineblock", "Parry's Mod", "Fail of Duty",
	"Fiba", "Portnight", "Silver gear liquid",
	"Lario"
]

var thing_to_like_fill_ins = [
	"eat chocolate", "play games", "murder",
	"stick chewing gun under the table", "press big red buttons", "examine dead bodies",
	"listen to bed time stories"
]

var PRIMARY_HEADLINES

var SECONDARY_HEADLINES

var primary_news_font = preload("res://UI/Fonts/Primary News.tres")

var previous_headline_template
var primary_headline = null

var previous_secondary_headline_template
var secondary_headline = null

onready var primary_news_label = get_node("VBoxContainer/MarginContainer/MarginContainer/Primary News")
onready var secondary_news_node = get_node("VBoxContainer/MarginContainer2/MarginContainer/Secondary News")

func _ready():
	for company in company_fill_ins:
		ceo_fill_ins.append("%s CEO" % company)
	
	person_name_fill_ins += specific_person_name_fill_ins + ceo_fill_ins
	
	PRIMARY_HEADLINES = [
		Headlines.new("%s lied about %s!", -0.2, -0.1, [
			person_name_fill_ins, positive_event_continuous_fill_ins
		]),
		Headlines.new("%s calls out %s for %s!", -0.3, -0.2, [
			person_name_fill_ins, person_name_fill_ins, negative_event_fill_ins
		]),
		Headlines.new("%s promises to %s!", -0.1, 0.05, [
			person_name_fill_ins, positive_event_fill_ins
		]),
		Headlines.new("%s to retire!", -0.3, -0.2, [
			person_name_fill_ins
		]),
		Headlines.new("%s fired!", -0.45, -0.2, [
			person_name_fill_ins
		]),
		Headlines.new("%s found dead!", -0.2, -0.1, [
			person_name_fill_ins
		]),
		Headlines.new("%s falsely accuses %s of %s!", -0.2, 0, [
			person_name_fill_ins, person_name_fill_ins, negative_event_fill_ins
		]),
		Headlines.new("%s dies from %s!", -0.2, -0.1, [
			person_name_fill_ins, death_reason_fill_ins
		]),
		Headlines.new("%s tells %s to %s", -0.3, -0.2, [
			person_name_fill_ins, person_name_fill_ins, negative_event_fill_ins
		]),
		Headlines.new("%s is facing charges for %s", -0.3, -0.2, [
			person_name_fill_ins, negative_event_fill_ins
		])
	]
	
	SECONDARY_HEADLINES = [
		Headlines.new("New p%s%s unveiling shortly", 0.1, 0.2, [
			device_fill_ins, number_fill_ins
		]),
		Headlines.new("%s %s coming out soon", 0.1, 0.2, [
			game_name_fill_ins, number_fill_ins
		]),
		Headlines.new("New %s store locations opening soon", 0.05, 0.1, [
			company_fill_ins
		]),
		Headlines.new("%s is hiring", 0.1, 0.2, [
			company_fill_ins
		]),
		Headlines.new("%s breaks into %s", -0.1, -0.05, [
			person_name_fill_ins, company_fill_ins
		]),
		Headlines.new("%s likes to %s", -0.1, 0.05, [
			person_name_fill_ins, thing_to_like_fill_ins
		])
	]

func add_random_primary_headline():
	primary_headline = Util.rand_element(PRIMARY_HEADLINES)
	while primary_headline == previous_headline_template:
		primary_headline = Util.rand_element(PRIMARY_HEADLINES)
	
	previous_headline_template = primary_headline
	
	var fill_ins = []
	
	for fill_in in primary_headline.fill_ins:
		var chosen_fill_in = Util.rand_element(fill_in)
		
		while chosen_fill_in in fill_ins:
			chosen_fill_in = Util.rand_element(fill_in)
		
		fill_ins.append(chosen_fill_in)
	
	primary_news_label.text = primary_headline.text % fill_ins
	
	var normalized_length = range_lerp(len(primary_news_label.text), 0, 100, 0, 1)
	var font_size = primary_length_to_font_size.interpolate(normalized_length)
	primary_news_font.size = font_size

func add_random_secondary_headline():
	secondary_headline = Util.rand_element(SECONDARY_HEADLINES)
	while secondary_headline == previous_secondary_headline_template:
		secondary_headline = Util.rand_element(SECONDARY_HEADLINES)
	
	previous_secondary_headline_template = secondary_headline
	
	var fill_ins = []
	
	for fill_in in secondary_headline.fill_ins:
		var chosen_fill_in = Util.rand_element(fill_in)
		
		while chosen_fill_in in fill_ins:
			chosen_fill_in = Util.rand_element(fill_in)
		
		fill_ins.append(chosen_fill_in)
	
	var text = secondary_headline.text % fill_ins
	secondary_news_node.current_news = text
	secondary_news_node.add_secondary_news(text)

func remove_primary_headline():
	primary_headline = null
	primary_news_label.text = ""
