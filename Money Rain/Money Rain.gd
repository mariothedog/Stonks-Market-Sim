extends Node2D

const MONEY_SCALE = Vector2(0.5, 0.5)
const MONEY_POS_Y_START = -100

var money_scene = preload("res://Money Rain/Money.tscn")

var raining = true

func _process(_delta):
	if raining:
		var money = money_scene.instance()
		money.position = Vector2(rand_range(0, get_viewport_rect().size.x), MONEY_POS_Y_START)
		money.target_dir = Vector2.DOWN
		add_child(money)
	else:
		if get_child_count() == 0:
			queue_free()

func _on_Stop_timeout():
	raining = false
