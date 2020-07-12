extends Node

func _ready():
	randomize()

func rand_element(array):
	return array[randi() % array.size()]
