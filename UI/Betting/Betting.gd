extends CenterContainer

onready var bet_amount_line_edit = get_node("MarginContainer/VBoxContainer/VBoxContainer/CenterContainer/Bet Amount")
onready var bet_up_button = get_node("MarginContainer/VBoxContainer/CenterContainer/Bet Up")
onready var bet_down_button = get_node("MarginContainer/VBoxContainer/CenterContainer2/Bet Down")
onready var balance_label = get_node("MarginContainer/VBoxContainer/VBoxContainer2/Balance")
onready var help_texture_rect = get_node("MarginContainer/VBoxContainer/Help")

onready var bet_up_button_orig_modulate = bet_up_button.modulate
onready var bet_down_button_orig_modulate = bet_down_button.modulate

const HOVER_DARKEN_AMOUNT = 0.15
const CLICK_DARKEN_AMOUNT = 0.3

# Bet up button
func _on_Bet_Up_pressed():
	pass

func _on_Bet_Up_mouse_entered():
	bet_up_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Bet_Up_mouse_exited():
	bet_up_button.modulate = bet_up_button_orig_modulate

func _on_Bet_Up_button_down():
	bet_up_button.modulate = bet_up_button_orig_modulate.darkened(CLICK_DARKEN_AMOUNT)

func _on_Bet_Up_button_up():
	bet_up_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

# Bet down button
func _on_Bet_Down_pressed():
	pass

func _on_Bet_Down_mouse_entered():
	bet_down_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)

func _on_Bet_Down_mouse_exited():
	bet_down_button.modulate = bet_down_button_orig_modulate

func _on_Bet_Down_button_down():
	bet_down_button.modulate = bet_down_button_orig_modulate.darkened(CLICK_DARKEN_AMOUNT)

func _on_Bet_Down_button_up():
	bet_down_button.modulate = bet_down_button_orig_modulate.darkened(HOVER_DARKEN_AMOUNT)
