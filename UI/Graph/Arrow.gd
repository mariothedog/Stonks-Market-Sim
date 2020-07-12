extends MarginContainer

const ARROW_LENGTH = 60
const ARROW_SUB_LENGTH = 50
const ARROW_SUB_ANGLE = deg2rad(120)

var arrow_position
var arrow_direction
var arrow_color
var arrow_thickness

func _draw():
	draw_colored_polygon(PoolVector2Array([
		arrow_position + arrow_direction * ARROW_LENGTH,
		arrow_position + arrow_direction.rotated(ARROW_SUB_ANGLE) * ARROW_SUB_LENGTH,
		arrow_position,
		arrow_position + arrow_direction.rotated(-ARROW_SUB_ANGLE) * ARROW_SUB_LENGTH
	]), arrow_color, PoolVector2Array(), null, null, true)
