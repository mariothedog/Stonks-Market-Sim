extends ScrollContainer

# Constants
const SCROLL_SPEED_X = 120

# Onready
onready var hbox = get_node("HBoxContainer")
onready var h_scrollbar = get_h_scrollbar()

onready var size_x = get_rect().size.x

func _process(delta):
	scroll_horizontal += SCROLL_SPEED_X * delta

func add_secondary_news(text):
	var label = hbox.get_child(0).duplicate()
	label.text = text + " - "
	hbox.add_child(label)

func _on_Add_Secondary_News_timeout():
	add_secondary_news("Obama is gone")
