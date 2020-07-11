extends MarginContainer

onready var headlines_collection_node = get_node("Headlines")

var headline_scene = preload("res://UI/News Headlines/Headline.tscn")

func _ready():
	randomize()

func _on_Create_Headline_timeout():
	var headline = headline_scene.instance()
	headlines_collection_node.add_child(headline)
	headline.generate()
	
	var max_x_pos = rect_size.x - headline.rect_size.x
	var max_y_pos = rect_size.y - headline.rect_size.y
	headline.rect_position = Vector2(rand_range(0, max_x_pos), rand_range(0, max_y_pos))
