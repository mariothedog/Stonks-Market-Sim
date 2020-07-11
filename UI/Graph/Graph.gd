extends TextureRect

const LINE_COLOR = Color("D45144")
const LINE_THICKNESS = 20
const TIME_DIVIDER = 15.0 # Bigger = Slower

var ORIGIN = Vector2(19, rect_size.y/2 - 10)
var x_value = ORIGIN.x
var y_value = ORIGIN.y
var maximum_y = rect_size.y/2 - 50

var points = []

func _process(_delta):
	update()

func _ready():
	randomize()
	
	for i in range(100):
		add_point(Vector2((i+1) * 50, rand_range(-maximum_y, maximum_y)))

func _draw():
	x_value = OS.get_ticks_msec() / TIME_DIVIDER
	var x_offset = Vector2(x_value, 0)
	
	var start_point = ORIGIN - x_offset
	
	var prev_point = start_point
	for point in points:
		var end_point = start_point + point + Vector2(prev_point.x, 0)
		draw_line(prev_point, end_point, LINE_COLOR, LINE_THICKNESS, true)
		prev_point = end_point

func add_point(point : Vector2):
	points.append(point)
