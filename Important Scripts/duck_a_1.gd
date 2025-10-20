extends Node3D

@onready var _animator_tree: AnimationTree = $AnimationTree

func is_walking():
	_animator_tree["parameters/conditions/is_walking"] = true
	_animator_tree["parameters/conditions/is_idle"] = false
	_animator_tree["parameters/conditions/is_honk"] = false
	_animator_tree["parameters/conditions/is_running"] = false
func is_running():
	_animator_tree["parameters/conditions/is_walking"] = false
	_animator_tree["parameters/conditions/is_idle"] = false
	_animator_tree["parameters/conditions/is_honk"] = false
	_animator_tree["parameters/conditions/is_running"] = true
func is_honk():
	_animator_tree["parameters/conditions/is_walking"] = false
	_animator_tree["parameters/conditions/is_idle"] = false
	_animator_tree["parameters/conditions/is_honk"] = true
	_animator_tree["parameters/conditions/is_running"] = false
func is_idle():
	_animator_tree["parameters/conditions/is_walking"] = false
	_animator_tree["parameters/conditions/is_idle"] = true
	_animator_tree["parameters/conditions/is_honk"] = false
	_animator_tree["parameters/conditions/is_running"] = false
