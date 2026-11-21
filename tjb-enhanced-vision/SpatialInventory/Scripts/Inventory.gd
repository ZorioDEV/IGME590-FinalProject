extends ColorRect

@export var grid_container : GridContainer
@export var item_layer : Control
@export var max_items: int

var item_id = -1

func _ready() -> void:
	if not InputMap.has_action("Spawn Item 1"):
		InputMap.add_action("Spawn Item 1")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_1
		InputMap.action_add_event("Spawn Item 1", ev)
	if not InputMap.has_action("Spawn Item 2"):
		InputMap.add_action("Spawn Item 2")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_2
		InputMap.action_add_event("Spawn Item 2", ev)
	if not InputMap.has_action("Spawn Item 3"):
		InputMap.add_action("Spawn Item 3")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_3
		InputMap.action_add_event("Spawn Item 3", ev)
	if not InputMap.has_action("Spawn Item 4"):
		InputMap.add_action("Spawn Item 4")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_4
		InputMap.action_add_event("Spawn Item 4", ev)
	if not InputMap.has_action("Spawn Item 5"):
		InputMap.add_action("Spawn Item 5")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_5
		InputMap.action_add_event("Spawn Item 5", ev)
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
	if not InputMap.has_action("Clear Items"):
		InputMap.add_action("Clear Items")
		var ev = InputEventKey.new()
		ev.physical_keycode = KEY_SPACE
		InputMap.action_add_event("Clear Items", ev)

func _input(event):
	if not is_visible_in_tree():
		return
	if event.is_action_pressed("Spawn Item 1"):
		spawn_item(load("res://SpatialInventory/Assets/Items/coin_item.tres"))
	if event.is_action_pressed("Spawn Item 2"):
		spawn_item(load("res://SpatialInventory/Assets/Items/sword_item.tres"))
	if event.is_action_pressed("Spawn Item 3"):
		spawn_item(load("res://SpatialInventory/Assets/Items/snake_item.tres"))
	if event.is_action_pressed("Spawn Item 4"):
		spawn_item(load("res://SpatialInventory/Assets/Items/cross_item.tres"))
	if event.is_action_pressed("Spawn Item 5"):
		spawn_item(load("res://SpatialInventory/Assets/Items/lightsaber_item.tres"))
	if event.is_action_pressed("Clear Items"):
		grid_container.reset_grid()
		for child in item_layer.get_children():
			if child is Item:
				child.queue_free()

func spawn_item(item_data: ItemData):
	if grid_container.active_item == null:
			var new_item := Item.new(item_data, grid_container.grid_slot_size)
			item_layer.add_child(new_item)
			grid_container.active_item = new_item
			item_id += 1
			item_id %= max_items
			new_item.id = item_id
