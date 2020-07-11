extends Node

class Headline_Category:
	var name
	var presets
	func _init(_name : String, _presets : Array):
		self.name = _name
		self.presets = _presets

class Headline_Preset:
	var text
	var min_start_fade_out_delay
	var max_start_fade_out_delay
	func _init(_text : String, _min_start_fade_out_delay : int = 0.8, _max_start_fade_out_delay : int = 1.2):
		self.text = _text
		self.min_start_fade_out_delay = _min_start_fade_out_delay
		self.max_start_fade_out_delay = _max_start_fade_out_delay

onready var technology_category = Headline_Category.new("Technology", [
	Headline_Preset.new("{name} tech!")
])
onready var gaming_category = Headline_Category.new("Gaming", [
	Headline_Preset.new("{name} game!")
])
onready var social_media_category = Headline_Category.new("Social Media", [
	Headline_Preset.new("{name} social media!")
])
onready var commerce_category = Headline_Category.new("Commerce", [
	Headline_Preset.new("{name} commerce!")
])
onready var food_category = Headline_Category.new("Food", [
	Headline_Preset.new("{name} food!")
])
onready var clothing_category = Headline_Category.new("Clothing", [
	Headline_Preset.new("{name} clothes!")
])
onready var search_engine_category = Headline_Category.new("Search Engine", [
	Headline_Preset.new("{name} searching!")
])
onready var entertainment_category = Headline_Category.new("Entertainment", [
	Headline_Preset.new("{name} entertainment!")
])
onready var information_category = Headline_Category.new("Information", [
	Headline_Preset.new("{name} info!")
])
