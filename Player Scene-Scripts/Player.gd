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

#scifi-rifle variables
@export var ammo = 100
@export var ammo_full = true
@export var ammo_empty = false
@export var can_shoot = true

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var SciFi_Rifle = $Head/Camera3D/SciFi_Rifle
@onready var aim_ray = $Head/Camera3D/AimRay
@onready var anim_player = $Head/Camera3D/AnimationPlayer
@onready var rifle_anim_player = $Head/Camera3D/SciFi_Rifle/RifleAnimPlayer
@onready var timer = $Timer

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40,), deg_to_rad(60))

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if ammo == 100:
		ammo_full = true
	else:
		ammo_full = false
		
	if ammo == 0:
		ammo_empty = true
		can_shoot = false
	else:
		ammo_empty = false
		
	
		
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
		
	var input_dir = Input.get_vector("Left","Right","Forward","Backwards")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if rifle_anim_player.is_playing():
		print("anim is playing")
	
	if is_on_floor():
		if direction: 
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
			
		if input_dir.y > 0:
			anim_player.play("bob")
		elif input_dir.y < 0:
			anim_player.play("bob")
		elif input_dir.x > 0:
			anim_player.play("bob")
		elif input_dir.x < 0:
			anim_player.play("bob")
		else:
			anim_player.stop()
		
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	reload()
	shoot()
	move_and_slide()
	
	
func shoot():
	if Input.is_action_pressed("Shoot"):
		if !ammo_empty and can_shoot:
			rifle_anim_player.play("shoot")
			ammo -= 1
			print(ammo)
	if aim_ray.is_colliding():
		if aim_ray.get_collider().is_in_group("enemy"):
			aim_ray.get_collider().hit()
			

func reload():
	if Input.is_action_just_pressed("reload"):
		if !ammo_full:
			rifle_anim_player.play("reload")
			timer.start()
			print("reloading")
			can_shoot = false
		else:
			print("gun is full")
		

func _on_timer_timeout():
	ammo = 100
	print("reloaded!")
	can_shoot = true
			
		
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

