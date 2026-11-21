extends Area3D

@export var item_data: ItemData


func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group("Player") or item_data == null:
		return

	if body.receive_item(item_data):
		print("Picked up ", item_data.item_name, "!")
		queue_free()
