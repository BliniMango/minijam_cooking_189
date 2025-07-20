extends Node2D

var completed_orders: Array[Dictionary] = []
@onready var pickup_area: Area2D = $PickupArea
@onready var food_ready_indicator: Sprite2D = $FoodReadyIndicator

signal food_picked_up(order_data)

func _ready():
	pickup_area.input_event.connect(_on_pickup_clicked)
	food_ready_indicator.visible = false

func add_completed_order(order: Dictionary):
	completed_orders.append(order)
	show_food_ready_indicator()

func show_food_ready_indicator():
	food_ready_indicator.visible = true
	
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property(food_ready_indicator, "modulate:a", 0.5, 0.5)
	tween.tween_property(food_ready_indicator, "modulate:a", 1.0, 0.5)

func update_food_ready_indicator():
	if completed_orders.size() == 0:
		food_ready_indicator.visible = false

func _on_pickup_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if completed_orders.size() > 0:
			var order = completed_orders.pop_front()
			food_picked_up.emit(order)
			update_food_ready_indicator()
			GameManager.player_pickup_food(order)
