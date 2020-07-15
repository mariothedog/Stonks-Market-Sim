extends MarginContainer

# =Constants=
# -Vectors-
const START_ARROW_DIR = Vector2.RIGHT
# -Colors-
const BACKGROUND_COLOR = Color.white
const AXIS_COLOR = Color.black
const NUMBERS_COLOR = Color.black
const SEGMENT_COLOR = Color.black
const LINE_COLOR = Color("D45144")
const ARROW_COLOR = Color("D45144")
# -Numbers-
const TIME_SPEED = 100.0
const MIN_PROGRESS_TO_NEXT_SEGMENT_FOR_NEXT_POINT = 0.9
const TIME_SPEED_TO_ADD_POINT_DELAY_NUMERATOR = 1000
const ARROW_SMOOTH_ROTATION_WEIGHT = 0.2
# Horizontal segments
const SEGMENT_HOR_HEIGHT = 10
const SEGMENT_HOR_GAP = 50
const SEGMENT_HOR_VALUE = 1
const SEGMENT_HOR_NUMBER_OFFSET_Y = 4
# Vertical segments
const SEGMENT_VER_WIDTH = 10
const SEGMENT_VER_GAP = 50
const SEGMENT_VER_VALUE = 1
const SEGMENT_VER_NUMBER_OFFSET_X = -8
const ZERO_NUMBER_OFFSET_X = 4
const ZERO_NUMBER_OFFSET_Y = 8
# Line
const LINE_X_VALUE_STEP = 0.01
const LINE_EXTRA_X_VALUE = 0.05
const LINE_THICKNESS = 3
# Arrow
const ARROW_SUB_ANGLE_RIGHT = 25
const ARROW_SUB_ANGLE_LEFT = 25
const ARROW_RIGHT_LENGTH = 25
const ARROW_LEFT_LENGTH = 25
const ARROW_DENT_LENGTH = 15

# =Public=
# -Fonts-
var axis_numbers_font = get_font("")
# -Vector2s-
var view_center_pos
var prev_arrow_dir = START_ARROW_DIR
# -Rect2s-
var adjusted_rect2
# -PoolVector2Arrays-
var raw_points = PoolVector2Array()
# -Arrays-
var points
# -Numbers-
var elapsed_x_offset_due_to_time = 0
var days = 0
var segments_left = 0
var segments_hor_total = 0
var segments_down = 0
var segments_ver_total = 0
var leftmost_x_value = 0
var progress_to_next_segment = 0
var total_ticks_msec_since_last_point_added = 0
var ticks_msec_since_last_point_added
var ticks_msec_before_add_point = TIME_SPEED_TO_ADD_POINT_DELAY_NUMERATOR/TIME_SPEED * SEGMENT_HOR_GAP

func _ready():
	randomize()
	
	raw_points.append(Vector2.ZERO)

func _on_Graph_item_rect_changed(): # This signal also accounts for changes in position as well as changes in size
	view_center_pos = rect_size / 2
	view_center_pos.x -= elapsed_x_offset_due_to_time
	
	adjusted_rect2 = Rect2(Vector2.ZERO, rect_size)

func _process(delta):
	var x_offset_due_to_time = TIME_SPEED * delta
	view_center_pos.x -= x_offset_due_to_time
	elapsed_x_offset_due_to_time += x_offset_due_to_time
	
	leftmost_x_value = -view_center_pos.x / SEGMENT_HOR_GAP - LINE_EXTRA_X_VALUE
	
	if sign(view_center_pos.x) == 1:
		progress_to_next_segment = 1 - abs(leftmost_x_value - int(leftmost_x_value))
	else:
		progress_to_next_segment = abs(leftmost_x_value - int(leftmost_x_value))
	
	ticks_msec_since_last_point_added = OS.get_ticks_msec() - total_ticks_msec_since_last_point_added
	if ticks_msec_since_last_point_added >= ticks_msec_before_add_point:
		days += 1
		raw_points.append(Vector2(days, rand_range(-1, 1)))
		total_ticks_msec_since_last_point_added = OS.get_ticks_msec()
	
	var leftmost_x_value_char_size = axis_numbers_font.get_string_size(str(leftmost_x_value))
	segments_left = view_center_pos.x / SEGMENT_HOR_GAP + leftmost_x_value_char_size.x / SEGMENT_HOR_GAP
	segments_hor_total = rect_size.x / SEGMENT_HOR_GAP - segments_left + leftmost_x_value_char_size.x / SEGMENT_HOR_GAP
	segments_down = view_center_pos.y / SEGMENT_VER_GAP
	segments_ver_total = rect_size.y / SEGMENT_VER_GAP - segments_down
	
	update()

func _draw():
	draw_background()
	draw_axis()
	draw_segments()
	draw_numbers()
	draw_points()

func draw_background():
	draw_rect(adjusted_rect2, BACKGROUND_COLOR, true)

func draw_axis():
	var ratio = view_center_pos / rect_size
	
	# x-axis
	var y_pos = view_center_pos.y
	if y_pos >= 0 and y_pos <= rect_size.y: # If inside the graph's boundaries
		var left_origin_pos = Vector2(view_center_pos.x - rect_size.x * ratio.x, y_pos)
		var right_origin_pos = Vector2(view_center_pos.x + rect_size.x * (1 - ratio.x), y_pos)
		draw_line(left_origin_pos, right_origin_pos, AXIS_COLOR)
	
	# y-axis
	var x_pos = view_center_pos.x
	if x_pos >= 0 and x_pos <= rect_size.x:
		var top_origin_pos = Vector2(x_pos, view_center_pos.y - rect_size.y * ratio.y)
		var bottom_origin_pos = Vector2(x_pos, view_center_pos.y + rect_size.y * (1 - ratio.y))
		draw_line(top_origin_pos, bottom_origin_pos, AXIS_COLOR) 

func draw_segments():
	# x-axis
	var middle_y_pos = view_center_pos.y
	var top_y_pos = middle_y_pos - SEGMENT_HOR_HEIGHT/2.0
	var bottom_y_pos = middle_y_pos + SEGMENT_HOR_HEIGHT/2.0 + 1
	
	if bottom_y_pos >= 0 and top_y_pos <= rect_size.y:
		for i in range(ceil(-segments_left), int(segments_hor_total) + 1):
			if i == 0:
				continue
			var x_pos = view_center_pos.x + i * SEGMENT_HOR_GAP
			draw_line(Vector2(x_pos, top_y_pos), Vector2(x_pos, bottom_y_pos), SEGMENT_COLOR)
	
	# y-axis
	var middle_x_pos = view_center_pos.x
	var left_x_pos = middle_x_pos - SEGMENT_VER_WIDTH/2.0 - 1
	var right_x_pos = middle_x_pos + SEGMENT_VER_WIDTH/2.0
	
	if right_x_pos >= 0 and left_x_pos <= rect_size.x:
		for i in range(ceil(-segments_down), int(segments_ver_total) + 1):
			if i == 0:
				continue
			var y_pos = view_center_pos.y + i * SEGMENT_VER_GAP
			draw_line(Vector2(left_x_pos, y_pos), Vector2(right_x_pos, y_pos), SEGMENT_COLOR)

func draw_numbers():
	# The numbers aren't visible outside the graph boundary because the "Clip Content" property is set to true
	
	# x-axis
	for i in range(ceil(-segments_left), ceil(segments_hor_total) + 1):
		if i == 0:
			continue
		
		var num = i * SEGMENT_HOR_VALUE
		var char_size = axis_numbers_font.get_string_size(str(num))
		var offset = Vector2(i * SEGMENT_HOR_GAP - char_size.x/2, char_size.y + SEGMENT_HOR_NUMBER_OFFSET_Y)
		var pos = view_center_pos + offset
		if adjusted_rect2.grow_individual(char_size.x, 0, 0, char_size.y).has_point(pos):
			draw_string(axis_numbers_font, pos, str(num), NUMBERS_COLOR)
	
	# y-axis
	for i in range(ceil(-segments_down), ceil(segments_ver_total) + 1):
		var num = -i * SEGMENT_VER_VALUE
		var char_size = axis_numbers_font.get_string_size(str(num))
		var offset = Vector2(-char_size.x + SEGMENT_VER_NUMBER_OFFSET_X, i * SEGMENT_VER_GAP + char_size.y/2)
		if i == 0:
			offset += Vector2(ZERO_NUMBER_OFFSET_X, ZERO_NUMBER_OFFSET_Y)
		var pos = view_center_pos + offset
		if adjusted_rect2.grow_individual(char_size.x, 0, 0, char_size.y).has_point(pos):
			draw_string(axis_numbers_font, pos, str(num), NUMBERS_COLOR)

func draw_points():
	points = []
	for raw_point in raw_points:
		var point = view_center_pos + Vector2(raw_point.x * SEGMENT_HOR_GAP, raw_point.y * SEGMENT_VER_GAP)
		points.append(point)
	
	var dir_to_last_point = START_ARROW_DIR
	if len(points) >= 2:
		var last_point = points.pop_back()
		var second_last_point = points[-1]
		dir_to_last_point = second_last_point.direction_to(last_point)
		var distance_to_last_point = (last_point - second_last_point).length()
		
		var connecting_point_progress = ticks_msec_since_last_point_added / ticks_msec_before_add_point
		if connecting_point_progress < 1:
			var connecting_point = second_last_point + dir_to_last_point * distance_to_last_point * connecting_point_progress
			points.append(connecting_point)
		
		if len(points) >= 2:
			draw_polyline(points, LINE_COLOR, LINE_THICKNESS, true)
		
		var arrow_dir = lerp(prev_arrow_dir, dir_to_last_point, ARROW_SMOOTH_ROTATION_WEIGHT)
		
		draw_arrow(points[-1], arrow_dir,
		ARROW_SUB_ANGLE_RIGHT, ARROW_SUB_ANGLE_LEFT,
		ARROW_RIGHT_LENGTH, ARROW_LEFT_LENGTH, ARROW_DENT_LENGTH,
		ARROW_COLOR, true)
		
		prev_arrow_dir = arrow_dir

func draw_arrow(pos: Vector2, dir: Vector2, sub_angle_right: float, sub_angle_left: float, right_length: float, left_length: float, dent_length: float, color: Color, antialiased: bool):
	pos += dir * 5
	draw_colored_polygon(PoolVector2Array([
		pos,
		pos + dir.rotated(deg2rad(180 - sub_angle_right)) * right_length,
		pos + dir * -dent_length,
		pos + dir.rotated(deg2rad(180 - -sub_angle_left)) * left_length
	]), color, PoolVector2Array(), null, null, antialiased)
