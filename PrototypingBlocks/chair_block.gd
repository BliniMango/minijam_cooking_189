extends Control

var seated_customer: Customer = null
@onready var panel = $Panel

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS

func _can_drop_data(_pos, data):
	print("Chair: Can drop data? ", data is Customer and seated_customer == null)
	return data is Customer and seated_customer == null

func _drop_data(_pos, data):
	print("Chair: Dropping customer ", data.customer_id)
	seated_customer = data
	
	# Remove customer from original position
	data.get_parent().remove_child(data)
	
	# Add customer to the chair
	add_child(data)
	
	# Position customer on the chair
	data.position = Vector2.ZERO
	data.size = panel.size
	
	print("Customer ", data.customer_id, " seated!")

func remove_customer():
	if seated_customer != null:
		remove_child(seated_customer)
		seated_customer = null
		print("Customer removed from chair")

func _get_drag_data(at_position):
	if seated_customer != null:
		var preview = Control.new()
		var preview_sprite = AnimatedSprite2D.new()
		preview_sprite.sprite_frames = seated_customer.animated_sprite.sprite_frames
		preview_sprite.animation = seated_customer.animated_sprite.animation
		preview_sprite.scale = Vector2(0.5, 0.5)
		
		preview.add_child(preview_sprite)
		set_drag_preview(preview)
		
		return seated_customer
	return null
