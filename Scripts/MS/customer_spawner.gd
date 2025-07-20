extends Node

const CUSTOMER_SCENE = preload("res://Scenes/Customers/customer.tscn")
var group_sizes = [2, 3, 4]

func _ready():
	var spawn_timer = $Timer
	#spawn_timer.new()
	#spawn_timer.wait_time = 5.0
	#spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	#spawn_timer.autostart = true
	#add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
func _on_spawn_timer_timeout():
	spawn_customer_group()

func spawn_customer_group() -> Array[CharacterBody2D]:
	var group_size = group_sizes[randi() % group_sizes.size()]
	var customer_group: Array[CharacterBody2D] = []
	
	# Create the group
	for i in range(group_size):
		var customer = CUSTOMER_SCENE.instantiate()
		get_parent().add_child(customer)
		customer.position = Vector2(50, 100 + i * 40)  # Queue formation
		customer_group.append(customer)
	
	# Set group and leader
	for i in range(customer_group.size()):
		customer_group[i].set_group(customer_group, i == 0)  # First is leader
	
	return customer_group
