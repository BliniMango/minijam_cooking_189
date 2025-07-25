extends Node
const CUSTOMER_SCENE = preload("res://Scenes/Customers/customer.tscn")
var group_sizes = [2, 3, 4]

func _ready():

	await get_tree().process_frame
	spawn_customer_group()

func spawn_customer_group():
	var group_size = group_sizes[randi() % group_sizes.size()]
	var customer_group: Array[CharacterBody2D] = []
	
	for i in range(group_size):
		var customer = CUSTOMER_SCENE.instantiate()
		get_parent().add_child(customer)  
		customer.position = Vector2(50, 100 + i * 40)
		customer_group.append(customer)
	
	for i in range(customer_group.size()):
		customer_group[i].set_group(customer_group, i == 0)
	
	print("Spawned group of ", group_size, " customers")
