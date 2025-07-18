class_name Customer
extends Control

@export var customer_id: int
@export var patience: int = 100
@export var order: Array[String] = []

@onready var animated_sprite = $AnimatedSprite2D

func _ready():

	custom_minimum_size = Vector2(64, 64)
	size = custom_minimum_size
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	if animated_sprite.sprite_frames != null:
		animated_sprite.play("idle")

func _get_drag_data(at_position):
	print("Customer: Starting drag for customer ", customer_id)
	
	var preview = Control.new()
	var preview_sprite = AnimatedSprite2D.new()
	
	preview_sprite.sprite_frames = animated_sprite.sprite_frames
	preview_sprite.animation = animated_sprite.animation
	preview_sprite.scale = Vector2(1, 1)
	
	preview.add_child(preview_sprite)
	set_drag_preview(preview)
	
	print("Customer: Drag data created")
	return self

func _can_drop_data(_pos, data):
	return false

func _drop_data(_pos, data):
	pass
