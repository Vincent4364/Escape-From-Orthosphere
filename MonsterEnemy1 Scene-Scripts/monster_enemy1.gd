extends Node3D

@onready var anim_player = $AnimationPlayer

@export var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	anim_player.play("Walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func hit():
	if health > 0: 
		health =- 10
	else:
		queue_free()
