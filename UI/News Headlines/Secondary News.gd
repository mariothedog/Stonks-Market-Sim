extends ScrollContainer

const SCROLL_SPEED_X = 120

onready var hbox = get_node("MarginContainer/HBoxContainer")
onready var h_scrollbar = get_h_scrollbar()

onready var size_x = get_rect().size.x

var current_news = "Press Start "

func _ready():
	for _i in range(4):
		add_secondary_news(current_news)

func _process(delta):
	scroll_horizontal += SCROLL_SPEED_X * delta

func add_secondary_news(text):
	var label = hbox.get_child(0).duplicate()
	label.text = text + " - "
	hbox.add_child(label)

func _on_Add_Secondary_News_timeout():
	if current_news:
		add_secondary_news(current_news)
