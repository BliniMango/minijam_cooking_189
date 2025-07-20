extends Area2D

@export var seat_capacity: int = 4
var is_occupied: bool = false
var seated_customers: Array = []
var seat_positions: Array = []
var orders_ready: bool = false
var customers_group_leader = null  # Declare this variable
var Customer  # Assuming you have a Customer class/enum

# Time to add signals yay :D
signal customers_seated(customers)
signal orders_taken(order_data)
signal order_taken(data) 

func _ready():
	seat_positions = $SeatPositions.get_children()
	
	area_entered.connect(_on_customer_group_dropped)
	input_event.connect(_on_table_clicked)
	
	collision_layer = 4 #Table layer
	collision_mask = 8 # Detection mask
	
func _on_customer_group_dropped(area):
	if is_occupied:
		return # Table is full
	
	if customers_group_leader == null:
		return
		
	var customer_group = customers_group_leader.get_group()
	if customer_group.size() > seat_capacity:
		return # Max group size
		
	seat_customer_group(customer_group)

func seat_customer_group(customer_group: Array):
	is_occupied = true
	seated_customers = customer_group
	
	for i in range(customer_group.size()):
		var customer = customer_group[i]
		var seat_position = seat_positions[i]
		
		customer.sit_at_postition(seat_position.global_position)
		customer.reparent($SeatedCustomers)
		customer.set_seated_state()
		
	_show_customers_seated() 
	customers_seated.emit(customer_group)

func _show_customers_seated():
	# Implement if needed
	pass
	
func _on_table_clicked(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if can_take_orders():
			take_orders()

func can_take_orders() -> bool:
	return is_occupied and not orders_ready and all_customers_ready_to_order()

func all_customers_ready_to_order() -> bool:
	for customer in seated_customers:
		if customer.current_state != Customer.state.READY_TO_ORDER:
			return false
	return true 
		
func take_orders():
	var order_data = []
	for customer in seated_customers:
		order_data.append(customer.generate_order())
		customer.set_waiting
