extends Node

func range_float(start: float, end: float, step: float): # Credit: https://github.com/godotengine/godot/issues/4164#issuecomment-488754325
	var res = Array()
	var i = start
	while i < end:
		res.push_back(i)
		i += step
	return res
