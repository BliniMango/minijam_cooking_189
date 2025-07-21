extends CharacterBody2D

enum State { WAITING_IN_QUEUE, BEING_DRAGGED, SEATED, READY_TO_ORDER, WAITING_FOR_FOOD, EATING }
var current_state = State.WAITING_IN_QUEUE
var customer_group: Array[CharacterBody2D] = []  
var group_leader: bool = false
var is_being_dragged: bool = false

func _ready():
	pass

func set_group(group: Array[CharacterBody2D], is_leader: bool = false):
	customer_group = group
	group_leader = is_leader

func get_group() -> Array[CharacterBody2D]:
	return customer_group

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if current_state == State.WAITING_IN_QUEUE:
			start_dragging_group()
		elif not event.pressed and is_being_dragged:
			stop_dragging_group()

func start_dragging_group():
	for customer in customer_group:
		customer.current_state = State.BEING_DRAGGED
		customer.is_being_dragged = true
	if group_leader:
		set_drag_leader()

func set_drag_leader():
	pass

func _process(delta):
	if is_being_dragged and group_leader:
		global_position = get_global_mouse_position()
		update_group_formation()

func update_group_formation():
	for i in range(customer_group.size()):
		if customer_group[i] != self:
			var offset = Vector2(-30 * (i + 1), 0) 
			customer_group[i].global_position = global_position + offset

func sit_at_position(seat_pos: Vector2):
	current_state = State.SEATED
	var tween = create_tween()
	tween.tween_property(self, "global_position", seat_pos, 0.3)
	tween.tween_callback(func():
		current_state = State.READY_TO_ORDER
		get_node("../CustomerSpawner").on_group_seated()
		)
	
func stop_dragging_group():
	for customer in customer_group:
		customer.is_being_dragged = false
		customer.current_state = State. WAITING_IN_QUEUE

func set_seated_state():
	current_state = State.SEATED

func generate_order():
	# Implement order generation logic soon
	return {}

func set_waiting_for_food_state():
	current_state = State.WAITING_FOR_FOOD
