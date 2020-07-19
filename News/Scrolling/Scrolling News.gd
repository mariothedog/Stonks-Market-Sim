extends MarginContainer

# Constants
const scroll_speed: int = 150

# Public Variables
var initial_max_scroll_value: int
var max_scroll_value: int
var current_news: String

# Onready Variables
onready var scroll_container: ScrollContainer = get_node("ScrollContainer")
onready var h_scrollbar: HScrollBar = scroll_container.get_h_scrollbar()
onready var label: Label = scroll_container.get_node("Label")

func _ready():
	set_news("hello there")

func _process(delta):
	scroll_container.scroll_horizontal += scroll_speed * delta
	if scroll_container.scroll_horizontal == max_scroll_value:
		scroll_container.scroll_horizontal = initial_max_scroll_value

func set_news(news):
	if current_news == news:
		return
	
	current_news = news
	
	label.text = current_news
	yield(h_scrollbar, "changed")
	initial_max_scroll_value = int(h_scrollbar.max_value - scroll_container.rect_size.x)
	
	label.text = "{news} - {news}".format({"news": current_news})
	yield(label, "resized")
	yield(h_scrollbar, "changed")
	max_scroll_value = int(h_scrollbar.max_value - scroll_container.rect_size.x)
