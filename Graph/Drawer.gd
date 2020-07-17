extends MarginContainer

# Constants
const TIME_SPEED: float = 500.0
const TIME_SPEED_TO_ADD_POINT_DELAY_NUMERATOR: float = 1000.0
const POINT_HOR_GAP: float = 5.0
const POINT_VER_GAP: float = 5.0
const SEGMENT_HOR_GAP: float = 50.0
const SEGMENT_VER_GAP: float = 50.0
const AXIS_WIDTH: float = 3.0
const AXIS_ANTIALIASED: bool = true
const AXIS_COLOR: Color = Color("6196AB")
const SEGMENT_COLOR: Color = AXIS_COLOR
const SEGMENT_WIDTH: float = 3.0
const SEGMENT_ANTIALIASED: bool = true
const MOVEMENT_X_WEIGHT: float = 0.05
const MOVEMENT_Y_WEIGHT: float = 0.05
const MOVEMENT_ON_RESIZE_X_WEIGHT: float = 0.2
const MOVEMENT_ON_RESIZE_Y_WEIGHT: float = 0.2
const SEGMENT_HOR_VALUE: float = 1.0
const SEGMENT_VER_VALUE: float = 1.0
const SEGMENT_NUMBER_COLOR = AXIS_COLOR
const X_SEGMENT_DOWN_AMOUNT: float = 12.0
const X_SEGMENT_UP_AMOUNT: float = 7.0
const Y_SEGMENT_LEFT_AMOUNT: float = 12.0
const Y_SEGMENT_RIGHT_AMOUNT: float = 7.0
const Y_SEGMENT_NUMBER_X_OFFSET: float = -3.0

# Public Variables
var origin: Vector2
var movement_offset: Vector2
var days: int = 0
var raw_points: PoolVector2Array = PoolVector2Array()
var current_y_value: float = 0
var ticks_msec_before_add_point: float = TIME_SPEED_TO_ADD_POINT_DELAY_NUMERATOR/TIME_SPEED * POINT_HOR_GAP
var segment_number_font: Font = get_font("")

# Private Variables
var _total_ticks_msec_since_last_point_added: float = 0
var _ticks_msec_since_last_point_added: float = 0

# Onready Variables
onready var graph: MarginContainer = get_parent()
onready var line_2d: Line2D = get_node("Line2D")

# Virtual _ready Method
func _ready():
	randomize()
	
	raw_points.append(Vector2(0, 0))

# Virtual Methods
func _process(_delta):
	_ticks_msec_since_last_point_added = OS.get_ticks_msec() - _total_ticks_msec_since_last_point_added
	if _ticks_msec_since_last_point_added >= ticks_msec_before_add_point:
		days += 1
		current_y_value += rand_range(-5, 5)
		raw_points.append(Vector2(days, current_y_value))
		_total_ticks_msec_since_last_point_added = OS.get_ticks_msec()
	
	movement_offset.x = lerp(movement_offset.x, -days * POINT_HOR_GAP + graph.rect_size.x/2, MOVEMENT_X_WEIGHT)
	movement_offset.y = lerp(movement_offset.y, -current_y_value * POINT_VER_GAP, MOVEMENT_Y_WEIGHT)
	
	_process_points()
	
	update()

func _draw():
	_draw_axis()
	_draw_number_segments()

# Public Methods
func get_real_point(raw_point: Vector2):
	return origin + raw_point * Vector2(POINT_HOR_GAP, POINT_VER_GAP) + movement_offset

# Private Methods
func _on_Graph_resized():
	origin = Vector2(0, graph.rect_size.y/2)
	if movement_offset == Vector2.ZERO:
		movement_offset.x = -days * POINT_HOR_GAP + graph.rect_size.x/2
		movement_offset.y = -current_y_value * POINT_VER_GAP
	else:
		movement_offset.x = lerp(movement_offset.x, -days * POINT_HOR_GAP + graph.rect_size.x/2, MOVEMENT_ON_RESIZE_X_WEIGHT)
		movement_offset.y = lerp(movement_offset.y, -current_y_value * POINT_VER_GAP, MOVEMENT_ON_RESIZE_Y_WEIGHT)

func _process_points():
	var all_points = PoolVector2Array()
	line_2d.points = PoolVector2Array()
	for i in len(raw_points):
		var raw_point = raw_points[i]
		var point = get_real_point(raw_point) 
		all_points.append(point)
		if i < len(raw_points) - 1:
			line_2d.add_point(point)
	
	if len(all_points) >= 2:
		var partial_point_progress = _ticks_msec_since_last_point_added / ticks_msec_before_add_point
		if partial_point_progress < 1:
			var dir_to_last_point = all_points[-2].direction_to(all_points[-1])
			var dist_to_last_point = all_points[-2].distance_to(all_points[-1])
			var partial_point = all_points[-2] + dir_to_last_point * dist_to_last_point * partial_point_progress
			line_2d.add_point(partial_point)

func _draw_axis():
	# x-axis
	var right_origin_pos = Vector2(graph.rect_size.x, origin.y + movement_offset.y)
	if right_origin_pos.y > 0 and right_origin_pos.y < graph.rect_size.y:
		var left_origin_pos = right_origin_pos + Vector2(-graph.rect_size.x, 0)
		draw_line(left_origin_pos, right_origin_pos, AXIS_COLOR, AXIS_WIDTH, AXIS_ANTIALIASED)
	
	# y-axis
	var bottom_origin_pos = Vector2(origin.x + movement_offset.x, graph.rect_size.y)
	if bottom_origin_pos.x > 0 and bottom_origin_pos.x < graph.rect_size.x:
		var top_origin_pos = bottom_origin_pos + Vector2(0, -graph.rect_size.y)
		draw_line(top_origin_pos, bottom_origin_pos, AXIS_COLOR, AXIS_WIDTH, AXIS_ANTIALIASED)

func _draw_number_segments():
	var offsetted_origin = origin + movement_offset
	
	# x-axis
	if offsetted_origin.y > 0 and offsetted_origin.y < graph.rect_size.y:
		var segments_left = movement_offset.x / SEGMENT_HOR_GAP
		var segments_right = rect_size.x / SEGMENT_HOR_GAP - segments_left
		for i in range(ceil(-segments_left), int(segments_right) + 1):
			if i == 0:
				continue
			var pos = offsetted_origin + Vector2(SEGMENT_HOR_GAP * i, 0)
			draw_line(pos + Vector2(0, -X_SEGMENT_UP_AMOUNT), pos + Vector2(0, X_SEGMENT_DOWN_AMOUNT), SEGMENT_COLOR, SEGMENT_WIDTH, SEGMENT_ANTIALIASED)
			
			var num = i * SEGMENT_HOR_VALUE
			var char_size = segment_number_font.get_string_size(str(num))
			var num_offset = Vector2(-char_size.x/2, char_size.y + X_SEGMENT_DOWN_AMOUNT)
			draw_string(segment_number_font, pos + num_offset, str(num), SEGMENT_NUMBER_COLOR)
	
	# y-axis
	if offsetted_origin.x > 0 and offsetted_origin.x < graph.rect_size.x:
		var up_segments = offsetted_origin.y / SEGMENT_VER_GAP
		var down_segments = graph.rect_size.y / SEGMENT_VER_GAP - up_segments
		for i in range(ceil(-up_segments), int(down_segments) + 1):
			if i == 0:
				continue
			var pos = offsetted_origin + Vector2(0, SEGMENT_VER_GAP * i)
			draw_line(pos + Vector2(-Y_SEGMENT_LEFT_AMOUNT, 0), pos + Vector2(Y_SEGMENT_RIGHT_AMOUNT, 0), SEGMENT_COLOR, SEGMENT_WIDTH, SEGMENT_ANTIALIASED)
			
			var num = i * SEGMENT_VER_VALUE
			var char_size = segment_number_font.get_string_size(str(num))
			var num_offset = Vector2(-char_size.x - Y_SEGMENT_LEFT_AMOUNT + Y_SEGMENT_NUMBER_X_OFFSET, char_size.y/2)
			draw_string(segment_number_font, pos + num_offset, str(num), SEGMENT_NUMBER_COLOR)
