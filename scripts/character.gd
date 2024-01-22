extends CharacterBody2D

var move_dir = Vector2.ZERO
var momentum = Vector2.ZERO
var speed = 120

func _physics_process(delta):
	# Gravity
	if !is_on_floor():
		momentum.y += 10
	else:
		momentum.y = 0
	
	# Player movement
	# right
	if Input.is_action_just_pressed("ui_right"):
		move_dir.x += 1
	elif Input.is_action_just_released("ui_right"):
		move_dir.x -= 1
	# left
	if Input.is_action_just_pressed("ui_left"):
		move_dir.x -= 1
	elif Input.is_action_just_released("ui_left"):
		move_dir.x += 1
		
	# Jumping
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		momentum.y -= 250
	
	# Moving
	velocity = (move_dir * speed) + momentum
	move_and_slide()
