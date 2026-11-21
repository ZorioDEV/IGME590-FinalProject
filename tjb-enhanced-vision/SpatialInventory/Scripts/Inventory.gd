extends ColorRect

@export var grid_container : GridContainer
@export var item_layer : Control
@export var max_items: int

var item_id = -1

func _ready() -> void:
	if not InputMap.has_action("Place Item"):
		InputMap.add_action("Place Item")
		var ev = InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_LEFT 
		InputMap.action_add_event("Place Item", ev)
	if not InputMap.has_action("Rotate Item"):
		InputMap.add_action("Rotate Item")
		var ev = InputEventMouseButton.new()
		ev.button_index = MOUSE_BUTTON_RIGHT 
		InputMap.action_add_event("Rotate Item", ev)

func spawn_item(item_data: ItemData) -> bool:
	if grid_container.active_item != null:
		return false
	var new_item := Item.new(item_data, grid_container.grid_slot_size)
	item_layer.add_child(new_item)
	grid_container.active_item = new_item
	item_id += 1
	item_id %= max_items
	new_item.id = item_id
	return true
