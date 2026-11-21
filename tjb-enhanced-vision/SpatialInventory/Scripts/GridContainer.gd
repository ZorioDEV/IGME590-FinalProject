extends GridContainer

@export var grid_elements : int = 10
@export var slot_scene : PackedScene

var grid : Array = []
var grid_width : float
var grid_height : float
var grid_slot_size : int
var v_sep := get_theme_constant("v_separation")
var h_sep := get_theme_constant("h_separation")

var item_ids : Array[int]
var items : Array[Item]
var active_item : Item = null
var active_slots : Array[GridSlot] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	grid_width = columns
	grid_height = ceil(float(grid_elements)/grid_width)
	
	# clear any existing children
	for child in get_children():
		child.queue_free()
	
	grid_setup()
	grid_slot_size = get_child(0).texture.get_size()[0]
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if active_item != null:
		var rotated_pivot := active_item.pivot_offset.rotated(active_item.rotation)
		active_item.global_position = get_global_mouse_position() - rotated_pivot
		display_availability(active_item)

func _input(event):
	if not is_visible_in_tree():
		return
	if active_item != null:
		if event.is_action_pressed("Place Item"):
			place_item(active_item)
		if event.is_action_pressed("Rotate Item"):
			active_item.rotate()
			display_availability(active_item)
	else:
		if event.is_action_pressed("Place Item"):
			pick_up_item(global_to_grid_coord(get_global_mouse_position()))

func grid_setup() -> void:
	var slot_count := grid_elements
	for r in range(grid_height):
		var row: Array = []
		
		for c in range(grid_width):
			if slot_count != 0:
				var new_slot := slot_scene.instantiate()
				add_child(new_slot)
				new_slot.grid_position = Vector2(r, c)
				row.append(new_slot)
				slot_count -= 1
		grid.append(row)
		
func display_availability(item: Item):
	# reset all slots
	for r in range(grid.size()):
		for c in range(grid[r].size()):
			grid[r][c].is_hovering = false
			
	# convert item's top left corner to grid coords
	var anchor : Vector2i = global_to_grid_coord(get_global_mouse_position() - item.get_logical_mouse_offset()/2)
	active_slots.clear()
	
	for offset in item.shape_offsets:
		var cords: Vector2i = anchor + offset
		# make sure coords are inside grid
		if cords.x >= 0 and cords.x < len(grid) and cords.y >= 0 and cords.y < len(grid[cords.x]):
			var slot: GridSlot = grid[cords.x][cords.y]
			active_slots.append(slot)
						
	for slot in active_slots:
		if slot.is_hovering == false:
			slot.is_hovering = true
	if len(active_slots) != len(item.shape_offsets):
		change_bulk_status(active_slots, GridSlot.Status.INVALID)
		return
	for slot in active_slots:
		if slot.isOccupied:
			change_bulk_status(active_slots, GridSlot.Status.INVALID)
			break
		else:
			slot.change_status(GridSlot.Status.VALID)

func place_item(item: Item):
	# check if we can place
	if len(active_slots) != len(item.shape_offsets):
		return
	for slot in active_slots:
		print("placed:")
		print(slot.grid_position)
		if slot.isOccupied:
			return
	# place item
	items.append(item)

	var min_r := int(active_slots[0].grid_position.x)
	var min_c := int(active_slots[0].grid_position.y)
	for slot in active_slots:
		min_r = mini(min_r, int(slot.grid_position.x))
		min_c = mini(min_c, int(slot.grid_position.y))
	var top_left_grid_pos := Vector2i(min_r, min_c)
	
	var grid_corner := grid_coord_to_global(top_left_grid_pos)
	var target_center := grid_corner + item.get_logical_mouse_offset()
	var rotated_pivot := active_item.pivot_offset.rotated(active_item.rotation)
	item.global_position = target_center - rotated_pivot
	
	for slot in active_slots:
		slot.isOccupied = true;
		slot.item_id = item.id
		slot.is_hovering = false
	active_item = null;		
		
func pick_up_item(grid_coords: Vector2i):
	if grid_coords.x >= 0 and grid_coords.x < grid.size() and grid_coords.y >= 0 and grid_coords.y < grid[grid_coords.x].size():
		if len(items) != 0:
			var id = grid[grid_coords.x][grid_coords.y].item_id
			for i in range(len(items)):
				if items[i].id == id:
					active_item = items[i]
					items.remove_at(i)
					break
			for r in range(grid.size()):
				for c in range(grid[r].size()):
					if grid[r][c].item_id == id and grid[r][c].isOccupied:
						grid[r][c].item_id = -1
						grid[r][c].isOccupied = false
	
func global_to_grid_coord(global_pos: Vector2) -> Vector2i:
	global_pos = get_global_transform().affine_inverse() * global_pos
	var cell_c := floori(global_pos.x/(grid_slot_size + v_sep) )
	var cell_r := floori(global_pos.y/(grid_slot_size + h_sep) )
	return Vector2i(cell_r,cell_c)
	
func grid_coord_to_global(coords: Vector2i) -> Vector2:
	if coords.x >= 0 and coords.x < grid.size() and coords.y >= 0 and coords.y < grid[coords.x].size():
		return grid[coords.x][coords.y].global_position
	return Vector2.ZERO

func change_bulk_status(slots: Array[GridSlot], status: GridSlot.Status):
	for slot in slots:
		slot.status = status
		
func reset_grid() -> void:
	items.clear()
	for r in range(grid.size()):
		for c in range(grid[r].size()):
			grid[r][c].reset()
		
		
		
		
		
		
		
		
		
		
		
