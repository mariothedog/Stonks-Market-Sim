extends TextureRect

const LINE_COLOR = Color("D45144")
const LINE_THICKNESS = 20
const TIME_DIVIDER = 30.0
const ARROW_LENGTH = 30

const POINT_GAP = 50
const NUM_START_STRAIGHT_LINE_POINTS = 17

const RIGHT_BARRIER_UV_X_MAX = 0.8

const LINE_SPEED = 20

var ORIGIN = Vector2(19, rect_size.y/2 - 9)
var x_value = ORIGIN.x
var y_value = ORIGIN.y
var maximum_y = rect_size.y/2 - 80

var can_move = false

var points = []

onready var graph_parent = get_parent()
onready var arrow_node = graph_parent.get_node("Arrow")
onready var left_barrier = graph_parent.get_node("Left Barrier")

onready var line_area_x = rect_size.x * RIGHT_BARRIER_UV_X_MAX

func _process(delta):
	if can_move:
		x_value += LINE_SPEED * delta
	
	update()

func _ready():
	arrow_node.arrow_color = LINE_COLOR
	arrow_node.arrow_thickness = LINE_THICKNESS
	
	for _i in range(NUM_START_STRAIGHT_LINE_POINTS):
		add_point(0, 0)

func _draw():
	var x_offset = Vector2(x_value, 0)
	
	var start_point = ORIGIN - x_offset
	
	var prev_point = start_point
	var dir
	for point in points:
		if prev_point.x > line_area_x:
			if len(points)-1 == points.find(point):
				add_point(0, 0)
			break
		
		var end_point = start_point + point - x_offset
		if end_point.x < -100:
			continue
		
		draw_line(prev_point, end_point, LINE_COLOR, LINE_THICKNESS, true)
		draw_circle(end_point, LINE_THICKNESS/2.0, LINE_COLOR)
		dir = prev_point.direction_to(end_point)
		prev_point = end_point
	
	arrow_node.arrow_position = prev_point
	arrow_node.arrow_direction = dir
	arrow_node.update()

func add_point(min_y_percent, max_y_percent): # Negative = Down, Positive = Up, Returns the change in the y-axis
	var x = len(points) * 50
	var y
	if len(points):
		y = points[-1].y + rand_range(-min_y_percent*maximum_y, -max_y_percent*maximum_y)
	else:
		y = rand_range(-min_y_percent*maximum_y, -max_y_percent*maximum_y)
	var point = Vector2(x, y)
	if sign(point.y) == -1:
		point.y = max(point.y, -maximum_y)
	else:
		point.y = min(point.y, maximum_y)
	points.append(point)
	return y
