extends Area3D


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		print("Picked up Item!")
		# do inventory stuff
		queue_free()
