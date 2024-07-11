extends CharacterBody3D

#movement variables
@export var speed = 5.0
const WALK_SPEED = 5.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

#physics variables
var gravity = 9.8
var can_move = true

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var shoot_anim = $Head/Camera3D/SciFi_Rifle/AnimationPlayer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40,), deg_to_rad(60))

func _physics_process(delta):
	move_and_slide()
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	var input_dir = Input.get_vector("Left","Right","Forward","Backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		print(float(is_on_floor()))
		if direction: 
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
			
		if input_dir.y > 0:
			$Head/AnimationPlayer.play("bob")
		elif input_dir.y < 0:
			$Head/AnimationPlayer.play("bob")
		elif input_dir.x > 0:
			$Head/AnimationPlayer.play("bob")
		elif input_dir.x < 0:
			$Head/AnimationPlayer.play("bob")
		else:
			$Head/AnimationPlayer.stop()
		
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	if Input.is_action_pressed("Shoot"):
		Global.shoot_anim.play("shoot")
	
		

	
#
#@onready var ui_script = $UI
#@onready var raycast = $Camera3D/RayCast3D
#
#@export var speed = 5.0
#@export var jump_velocity = 4.5
#@export var turn_speed = 0.05
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
#
#func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#add_to_group("player")
#
#
#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y -= gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#velocity.y = jump_velocity
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var input_dir = Input.get_vector("left", "right", "forward", "backward")
	#var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * speed
		#velocity.z = direction.z * speed
	#else:
		#velocity.x = move_toward(velocity.x, 0, speed)
		#velocity.z = move_toward(velocity.z, 0, speed)
	#
	#if Input.is_action_pressed("attack"):
		#if ui_script.can_shoot:
			#shoot()
#
	#move_and_slide()
	#
	#
#func _input(event):
	#if event is InputEventMouseMotion:
		#rotate(Vector3.UP, event.relative.x * -0.001)
#
#func shoot():
	#if raycast.is_colliding() and raycast.get_collider().has_method("die"):
		#raycast.get_collider().die()
	#
#func damage():
	#Global.player_health -= 10
	#print(Global.player_health)
	#if Global.player_health <= 0:
		#get_tree().quit()
