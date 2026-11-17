class_name Item
extends TextureRect

var shape_offsets : Array[Vector2i]
var item_name: String
var item_grid: Array[Array]
var mouse_offset : Vector2
var id: int = 0
var grid_slot_size: int

func _init(item_data : ItemData, grid_slot_size : int) -> void:
	texture = item_data.texture
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	shape_offsets = item_data.shape_offsets
	item_name = item_data.item_name
	
	self.grid_slot_size = grid_slot_size
	size = calculate_texture_size(grid_slot_size) * 0.85
	mouse_offset = size/2.0
	pivot_offset = mouse_offset
	
func rotate():
	var new_offsets: Array[Vector2i] = []
	var min_x := 999999
	var min_y := 999999
	
	for offset in shape_offsets:
		var rotated := Vector2i(offset.y, -offset.x)
		new_offsets.append(rotated)
		
		# get lowest bound
		min_x = mini(min_x, rotated.x)
		min_y = mini(min_y, rotated.y)
		
	# normalize (shift back to 0,0)
	for i in range(new_offsets.size()):
		new_offsets[i].x -= min_x
		new_offsets[i].y -= min_y
			
	shape_offsets = new_offsets
	rotation_degrees += 90
	
func calculate_texture_size(grid_slot_size: int) -> Vector2:
	var max_x := 0
	var max_y := 0
	for offset in shape_offsets:
		max_x = maxi(max_x, offset.x)
		max_y = maxi(max_y, offset.y)
	return Vector2((max_y + 1) * grid_slot_size, (max_x + 1) * grid_slot_size)
	
# Returns the physical pixel distance from the center (mouse) to the logical top-left
func get_logical_mouse_offset() -> Vector2:
	var max_r := 0
	var max_c := 0
	for offset in shape_offsets:
		max_r = maxi(max_r, offset.x)
		max_c = maxi(max_c, offset.y)
	
	return Vector2((max_c + 1) * grid_slot_size / 2.0, (max_r + 1) * grid_slot_size / 2.0)
	
#func _draw() -> void:
	##Local coordinates bounding rect starts at (0,0) with the node's current size
	#var local_rect = Rect2(Vector2.ZERO, size)
	#
	## Draw an unfilled rectangle outline
	#draw_rect(local_rect, Color.GREEN, false, 1.0)
