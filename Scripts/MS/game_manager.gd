# GameManager.gd
extends Node

@onready var kitchen = $Kitchen

var player_holding_food: Dictionary = {}

func _ready():
	#kitchen.food_picked_up.connect(_on_food_picked_up)
	pass
func _on_food_picked_up(order_data: Dictionary):
	player_holding_food = order_data
	print("Picked up order: ", order_data)

func player_pickup_food(order_data: Dictionary):
	_on_food_picked_up(order_data)

func deliver_food_to_table(table: Node):
	if player_holding_food.is_empty():
		return
	
	table.receive_food(player_holding_food)
	player_holding_food.clear()
