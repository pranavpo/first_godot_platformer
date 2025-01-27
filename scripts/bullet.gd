extends Area2D

var speed:float = 500
var direction = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	look_at(global_position + direction)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction * speed * delta  # Move the bullet in the given direction
	rotation = direction.angle()
	if not get_viewport_rect().has_point(global_position):
		queue_free()  # Destroy the bullet if it goes out of view


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):  # Assuming enemy nodes are in an "enemy" group
		if body.hits > 1:
			body.hits -= 1
		else:
			body.queue_free()  # Free the enemy
		queue_free()  # Free the bullet
		
	if body.is_in_group("floor"):
		if(body.position.y >= body.initial_position.y):
			body.position.y -= 10
		queue_free()
