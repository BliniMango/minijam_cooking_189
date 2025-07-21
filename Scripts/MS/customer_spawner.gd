extends Node

const CUSTOMER_SCENE = preload("res://Scenes/Customers/customer.tscn")
var group_sizes = [2, 3, 4]
var can_spawn_new_group = true
var current_waiting_group: Array[CharacterBody2D] = []

func _ready():
	spawn_current_waiting_group()

func spawn_current_waiting_group() -> Array[CharacterBody2D]:
	if not can_spawn_new_group:
		return []
	
	var group_size = group_sizes[randi() % group_sizes.size()]
	current_waiting_group = []
	
	# Create the group
	for i in range(group_size):
		var customer = CUSTOMER_SCENE.instantiate()
		get_parent().add_child(customer)
		customer.position = Vector2(50, 100 + i * 40)
		current_waiting_group.append(customer)
	
	# Set group and leader
	for i in range(current_waiting_group.size()):
		current_waiting_group[i].set_group(current_waiting_group, i == 0)  # First is leader
	
	return current_waiting_group
