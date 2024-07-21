extends Node3D


@onready var crosshair = $UI/crosshair
@onready var crosshair_hit = $UI/crosshair_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	crosshair.position.x = get_viewport().size.x / 2 - 23
	crosshair.position.y = get_viewport().size.y / 2 - 23
	crosshair_hit.position.x = get_viewport().size.x / 2 - 23
	crosshair_hit.position.y = get_viewport().size.y / 2 - 23

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
