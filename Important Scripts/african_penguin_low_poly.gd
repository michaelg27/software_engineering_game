extends CharacterBody3D
@export_group("Camera")
@export_range(0.0, 1.0) var mouse_sensitivity := 0.10

@export_group("Movement")
@export var move_speed := 16.0
@export var acceleration := 200.0
@export var rotation_speed := 12.0
@export var jump_impulse := 24.0


@onready var _camera_pivot: Node3D = %CamaraNode
@onready var _camera: Camera3D = %Camera3D
@onready var _skin: Node3D = %PointOffset
@onready var _animator: AnimationPlayer = %AnimationPlayer
@onready var _animator_tree: AnimationTree = %AnimationTree 
@onready var _jump_particles: Node3D = $JumpParticles
@onready var _hummingbird: Node3D = $PointOffset/Hummingbird
@onready var _penguin: Node3D = %PenguinModel
@onready var _duck: Node3D = $PointOffset/Duck_A1

var _camera_input_direction := Vector2.ZERO
var _last_movement_direction := Vector3.BACK
var gravity := -50.0
var amount_of_jumps = 1
var is_in_penguin := true
var is_in_hummingbird := false
var is_in_duck := false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _unhandled_input(event: InputEvent) -> void:
	var is_camera_motion := (
		event is InputEventMouseMotion and 
		Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	)
	if is_camera_motion:
		_camera_input_direction = event.screen_relative * mouse_sensitivity

func _physics_process(delta: float) -> void:
	_camera_pivot.rotation.x += _camera_input_direction.y * delta
	_camera_pivot.rotation.x = clamp(_camera_pivot.rotation.x, -PI/12.0, PI / 3.0)
	_camera_pivot.rotation.y -= _camera_input_direction.x * delta
	
	_camera_input_direction = Vector2.ZERO
	
	
	
	if Input.is_action_just_pressed("transform1"):
		_penguin.visible = true
		_hummingbird.visible = false
		_duck.visible = false
		is_in_penguin = true
		is_in_hummingbird = false
		gravity = -60.0
	if Input.is_action_just_pressed("transform3"):
		_penguin.visible = false
		_hummingbird.visible = false
		_duck.visible = true
		is_in_duck = true
		is_in_penguin = false
		is_in_hummingbird = false
		gravity = -50.0
	if Input.is_action_just_pressed("transform2"):
		_penguin.visible = false
		_hummingbird.visible = true
		_duck.visible = false
		is_in_hummingbird = true
		is_in_penguin = false
		gravity = -3.0
	
	
	var raw_input := Input.get_vector("left", "right", "forward", "back")
	var forward := _camera.global_basis.x
	var right := _camera.global_basis.z
	var sprinting := Input.is_action_pressed("sprint")
	if is_in_duck:
		if sprinting:
			move_speed = 40.0
			acceleration = 200.0
		else:
			move_speed = 20.0
			acceleration = 200.0
	if is_in_penguin:
		if sprinting:
			move_speed = 25.0
			acceleration = 200.0
		else:
			move_speed = 12.5
			acceleration = 200.0
	if is_in_hummingbird:
		move_speed = 16.0
		acceleration = 200.0
	
	var move_direction := forward * raw_input.x + right * raw_input.y
	move_direction.y = 0.0
	move_direction = move_direction.normalized()
	
	var y_velocity := velocity.y
	velocity.y = 0.0
	velocity = velocity.move_toward(move_direction * move_speed, acceleration * delta)
	if is_in_duck:
		velocity.y = y_velocity + gravity * delta
	if is_in_penguin:
		velocity.y = y_velocity + gravity * delta
		var is_starting_jump := Input.is_action_just_pressed("jump")
		if is_starting_jump and amount_of_jumps > 0:
			if !is_on_floor():
				_jump_particles.emitJump()
			velocity.y = jump_impulse
			amount_of_jumps = amount_of_jumps - 1
	if is_in_hummingbird:
		velocity.y = gravity
	
	
	
	move_and_slide()
	
	
	if move_direction.length() > 0.2:
		_last_movement_direction = move_direction
		if sprinting:
			_animator_tree["parameters/conditions/is_idle"] = false
			_animator_tree["parameters/conditions/is_walking"] = false
			_animator_tree["parameters/conditions/is_sprint"] = true
			_duck.is_running()
			
		else:
			_animator_tree["parameters/conditions/is_idle"] = false
			_animator_tree["parameters/conditions/is_walking"] = true
			_animator_tree["parameters/conditions/is_sprint"] = false
			_duck.is_walking()
			
	else:
		_animator_tree["parameters/conditions/is_walking"] = false
		_animator_tree["parameters/conditions/is_idle"] = true
		_animator_tree["parameters/conditions/is_sprint"] = false
		_duck.is_idle()
	
	var target_angle := Vector3.BACK.signed_angle_to(_last_movement_direction, Vector3.UP)
	_skin.global_rotation.y = lerp_angle(_skin.global_rotation.y, target_angle, rotation_speed * delta)
	if is_on_floor():
		amount_of_jumps = 2
	
	
	
