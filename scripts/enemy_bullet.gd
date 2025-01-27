extends Area2D

@export var speed: float = 200.0  # Movement speed in pixels per second
@export var direction: Vector2 = Vector2(1, 0)  # Direction to move (normalized)
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#print("Area2D is ready!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	move_area(delta)

func round_vector_to_zero_or_one(v: Vector2) -> Vector2:
	return Vector2(round(v.x), round(v.y))
# Move the Area2D in the specified direction.
func move_area(delta: float) -> void:
	global_position += round_vector_to_zero_or_one(direction) * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Assuming enemy nodes are in an "enemy" group
		if body.hp > 1:
			AutoloadScript.emit_player_hit()
			body.hp -= 10
		else:
			body.queue_free()  # Free the enemy
		queue_free()  # Free the bullet
