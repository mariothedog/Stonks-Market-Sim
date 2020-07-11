tool
extends MarginContainer

# Constants
const OUTLINE_SATURATION = 0.7
const OUTLINE_VALUE = 0.6
const OUTLINE_ALPHA = 1

const INNER_SATURATION = 0.5
const INNER_VALUE = 0.8
const INNER_ALPHA = 1

# Onready
onready var outline_color = get_node("Outline")
onready var inner_background_color = get_node("MarginContainer/Inner Background")
onready var headline_text = get_node("MarginContainer/CenterContainer/HBoxContainer/Headline")
onready var animation_player = get_node("AnimationPlayer")
onready var fade_out_delay_timer = get_node("Fade Out Delay")

func _unhandled_input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		generate()

func generate():
	# Color
	var hue = randf()
	outline_color.color = Color.from_hsv(hue, OUTLINE_SATURATION, OUTLINE_VALUE, OUTLINE_ALPHA)
	inner_background_color.color = Color.from_hsv(hue, INNER_SATURATION, INNER_VALUE, INNER_ALPHA)
	
	# Headline
	var stock = Util.rand_element(StockManager.stocks_list)
	var preset = Util.rand_element(stock.headline_category.presets)
	headline_text.text = preset.text.format({"name": stock.name})
	
	# Public outcry - TODO
	
	# Fade out delay
	fade_out_delay_timer.wait_time = rand_range(preset.min_start_fade_out_delay, preset.max_start_fade_out_delay)

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Fade In":
			fade_out_delay_timer.start()
		"Fade Out":
			remove()

func _on_Fade_Out_Delay_timeout():
	animation_player.play("Fade Out")

func remove():
	queue_free()
