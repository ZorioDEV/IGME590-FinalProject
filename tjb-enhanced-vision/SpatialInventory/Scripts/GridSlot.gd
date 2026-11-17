class_name GridSlot
extends TextureRect

var isOccupied := false
var status := Status.DEFAULT
var is_hovering := false
var grid_position := Vector2(0,0)
var position_check := Vector2(0,0)
var texture_size : int
var item_id : int = -1

enum Status
{
	DEFAULT,
	INVALID,
	VALID,
	OCCUPIED
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match status:
		Status.DEFAULT:
			modulate = Color.WHITE
		Status.INVALID:
			modulate = Color.RED
		Status.VALID:
			modulate = Color.GREEN
		Status.OCCUPIED:
			modulate = Color.ORANGE

	if not is_hovering:
		change_status(Status.DEFAULT)			
			
func change_status(new_status : Status):
	if status != new_status:
		status = new_status
		
func reset() -> void:
	isOccupied = false
	is_hovering = false
	status = Status.DEFAULT
	
