extends MarginContainer

signal money_value_changed

enum BET_DIR {
	NONE = 0,
	UP = 1,
	DOWN = -1
}

var current_bet = 0
var current_bet_dir = BET_DIR.NONE

onready var money_rain_scene = preload("res://Money Rain/Money Rain.tscn")

onready var graph_background = get_node("VBoxContainer/HBoxContainer/Graph/Background")
onready var tutorial = get_node("CanvasLayer/Tutorial")
onready var news_headline = get_node("VBoxContainer/News Headline")
onready var secondary_news = news_headline.get_node("VBoxContainer/MarginContainer2/MarginContainer/Secondary News")
onready var secondary_news_label_hbox = secondary_news.get_node("MarginContainer/HBoxContainer")

onready var first_primary_headline_timer = get_node("First Primary Headline")
onready var add_primary_point_timer = get_node("Add Primary Point")
onready var primary_headline_delay = get_node("Primary Headline Delay")

onready var betting = get_node("VBoxContainer/HBoxContainer/Betting")

onready var win_bet_sfx = get_node("Win Bet")
onready var lose_bet_sfx = get_node("Lose Bet")
onready var game_over_sfx = get_node("Game Over")

func _ready():
	tutorial.visible = false
	betting.disable_bet_buttons()

func start():
	graph_background.can_move = true
	first_primary_headline_timer.start()
	secondary_news.scroll_horizontal = 0
	for i in range(1, secondary_news_label_hbox.get_child_count()):
		var child = secondary_news_label_hbox.get_child(i)
		child.queue_free()

func _on_Betting_start_pressed():
	start()
	betting.enable_bet_buttons()

func _on_Betting_tutorial_tex_rect_mouse_entered():
	tutorial.visible = true

func _on_Betting_tutorial_tex_rect_mouse_exited():
	tutorial.visible = false

func _on_First_Primary_Headline_timeout():
	news_headline.add_random_primary_headline()
	news_headline.add_random_secondary_headline()
	add_primary_point_timer.start()

func _on_Add_Primary_Point_timeout():
	var min_y = news_headline.primary_headline.start_min_stock_change + news_headline.secondary_headline.start_min_stock_change
	var max_y = news_headline.primary_headline.start_max_stock_change + news_headline.secondary_headline.start_max_stock_change
	var y_change = graph_background.add_point(min_y, max_y)
	if current_bet > 0:
		if sign(current_bet_dir) == -sign(y_change):
			betting.money += current_bet * 2
			win_bet_sfx.play()
			rain_money()
			emit_signal("money_value_changed")
		else:
			if betting.money <= 0:
				game_over()
			else:
				lose_bet_sfx.play()
	
	current_bet = 0
	
	news_headline.remove_primary_headline()
	
	betting.disable_bet_buttons()
	primary_headline_delay.start()

func rain_money():
	var money_rain = money_rain_scene.instance()
	add_child(money_rain)

func _on_Primary_Headline_Delay_timeout():
	news_headline.add_random_primary_headline()
	
	betting.enable_bet_buttons()

func _on_Betting_bet_up_pressed_successfully():
	current_bet = int(betting.bet_amount_line_edit.text)
	betting.money -= current_bet
	emit_signal("money_value_changed")
	current_bet_dir = BET_DIR.UP
	betting.disable_bet_buttons()
	betting.bet_amount_line_edit.text = ""

func _on_Betting_bet_down_pressed_successfully():
	current_bet = int(betting.bet_amount_line_edit.text)
	betting.money -= current_bet
	emit_signal("money_value_changed")
	current_bet_dir = BET_DIR.DOWN
	betting.disable_bet_buttons()
	betting.bet_amount_line_edit.text = ""

func game_over():
	game_over_sfx.play()
	yield(game_over_sfx, "finished")
	
	if get_tree().change_scene("res://UI/Game Over/Game Over.tscn") != OK:
		print_debug("An error occurred while attempting to change to the Game Over scene.")
