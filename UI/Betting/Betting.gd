extends MarginContainer

signal start_pressed
signal tutorial_tex_rect_mouse_entered
signal tutorial_tex_rect_mouse_exited
signal bet_up_pressed_successfully
signal bet_down_pressed_successfully

onready var bet_amount_line_edit = get_node("CenterContainer/MarginContainer/VBoxContainer/VBoxContainer2/CenterContainer/Bet Amount")
onready var bet_up_button = get_node("CenterContainer/MarginContainer/VBoxContainer/Bet Up")
onready var bet_down_button = get_node("CenterContainer/MarginContainer/VBoxContainer/Bet Down")
onready var start_button = get_node("CenterContainer/MarginContainer/VBoxContainer/VBoxContainer/Start")
onready var balance_label = get_node("CenterContainer/MarginContainer/VBoxContainer/VBoxContainer3/Balance")
onready var tutorial_tex_rect = get_node("CenterContainer/MarginContainer/VBoxContainer/CenterContainer3/Tutorial")
onready var animation_player = get_node("AnimationPlayer")

onready var invalid_bet_sfx = get_node("CenterContainer/MarginContainer/VBoxContainer/VBoxContainer2/CenterContainer/Invalid Bet")
onready var button_press_sfx = get_node("Button Press")

onready var bet_up_button_orig_modulate = bet_up_button.modulate
onready var bet_down_button_orig_modulate = bet_down_button.modulate
onready var start_button_orig_modulate = start_button.modulate
onready var tutorial_texture_rect_orig_modulate = tutorial_tex_rect.modulate

const HOVER_DARKEN_AMOUNT = 0.15
const CLICK_DARKEN_AMOUNT = 0.3

var money = 20

func _ready():
	update_balance_label()

func update_balance_label():
	balance_label.text = "$" + str(money)

# Bet up button
func _on_Bet_Up_pressed():
	button_press_sfx.play()
	if len(bet_amount_line_edit.text) > 0:
		emit_signal("bet_up_pressed_successfully")
	else:
		invalid_bet_sfx.play()

func _on_Bet_Up_mouse_entered():
	if not bet_up_button.disabled:
		bet_up_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Bet_Up_mouse_exited():
	bet_up_button.modulate = bet_up_button_orig_modulate

func _on_Bet_Up_button_down():
	if not bet_up_button.disabled:
		bet_up_button.modulate = bet_up_button_orig_modulate.darkened(CLICK_DARKEN_AMOUNT)

func _on_Bet_Up_button_up():
	if not bet_up_button.disabled:
		bet_up_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

# Bet down button
func _on_Bet_Down_pressed():
	button_press_sfx.play()
	if len(bet_amount_line_edit.text) > 0:
		emit_signal("bet_down_pressed_successfully")
	else:
		invalid_bet_sfx.play()

func _on_Bet_Down_mouse_entered():
	if not bet_down_button.disabled:
		bet_down_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Bet_Down_mouse_exited():
	bet_down_button.modulate = bet_down_button_orig_modulate

func _on_Bet_Down_button_down():
	if not bet_down_button.disabled:
		bet_down_button.modulate = bet_down_button_orig_modulate.darkened(CLICK_DARKEN_AMOUNT)

func _on_Bet_Down_button_up():
	if not bet_down_button.disabled:
		bet_down_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

# Start button
func _on_Start_pressed():
	button_press_sfx.play()
	emit_signal("start_pressed")
	
	start_button.disabled = true

func _on_Start_mouse_entered():
	start_button.modulate = start_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Start_mouse_exited():
	start_button.modulate = start_button_orig_modulate

func _on_Start_button_down():
	start_button.modulate = start_button_orig_modulate.darkened(CLICK_DARKEN_AMOUNT)

func _on_Start_button_up():
	start_button.modulate = start_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Tutorial_mouse_entered():
	emit_signal("tutorial_tex_rect_mouse_entered")
	tutorial_tex_rect.modulate = tutorial_texture_rect_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Tutorial_mouse_exited():
	emit_signal("tutorial_tex_rect_mouse_exited")
	tutorial_tex_rect.modulate = tutorial_texture_rect_orig_modulate

func _on_Bet_Amount_text_changed(new_text):
	if not new_text.empty() and (not new_text.is_valid_integer() or int(new_text) > money or int(new_text) == 0):
		bet_amount_line_edit.text = ""
		animation_player.play("Invalid Bet")
		invalid_bet_sfx.play()

func disable_bet_buttons():
	bet_up_button.disabled = true
	bet_down_button.disabled = true
	bet_amount_line_edit.editable = false

func enable_bet_buttons():
	bet_up_button.disabled = false
	bet_down_button.disabled = false
	bet_amount_line_edit.editable = true

func _on_Level_money_value_changed():
	update_balance_label()
