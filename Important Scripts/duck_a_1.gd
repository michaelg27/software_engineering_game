extends Node3D

@onready var _animator_tree: AnimationTree = $AnimationTree
@onready var _timer: Timer = $CooldownTimer
@onready var _ray_cast :RayCast3D = $RayCast3D

var is_honking := false
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
func honk():
	is_honking = true
	print("started honking")
	_timer.start()
	_animator_tree["parameters/conditions/is_walking"] = false
	_animator_tree["parameters/conditions/is_idle"] = false
	_animator_tree["parameters/conditions/is_honk"] = true
	_animator_tree["parameters/conditions/is_running"] = false
func is_idle():
	_animator_tree["parameters/conditions/is_walking"] = false
	_animator_tree["parameters/conditions/is_idle"] = true
	_animator_tree["parameters/conditions/is_honk"] = false
	_animator_tree["parameters/conditions/is_running"] = false



func _on_cooldown_timer_timeout() -> void:
	is_honking = false
	print("Stopped Honking")
