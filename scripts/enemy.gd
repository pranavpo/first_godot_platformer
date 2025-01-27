extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -400.0
@onready var player: CharacterBody2D = $"../Player"
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var turn_timer: Timer = $TurnTimer
@onready var direction = Vector2.ZERO
@onready var shoot_timer: Timer = $ShootTimer
const bullet_scene = preload("res://scenes/enemy_bullet.tscn")
var hits = 3
var left_limit = 0
var right_limit = 640
func _ready():
	_update_player_direction()
	# Start the timer when the enemy is ready
	turn_timer.start()  
	shoot_timer.start()

# This function will be called when the timer times out
func _on_turn_timer_timeout() -> void:
	# Only update the direction when the timer runs out
	direction = (player.global_position - global_position).normalized()

	# Restart the timer to control the next direction change
	turn_timer.start()

func _physics_process(delta: float) -> void:
	# Add gravity if the enemy is not on the floor
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Move the enemy based on the current direction
	if direction.x < 0:
		global_position.x -= SPEED * delta  # Use SPEED for movement
		sprite_2d.flip_h = false
	elif direction.x > 0:
		global_position.x += SPEED * delta  # Use SPEED for movement
		sprite_2d.flip_h = true
	
	# Apply sliding physics
	move_and_slide()
	
func _update_player_direction():
	# Calculate the area on both sides
	var left_area = global_position.x - left_limit
	var right_area = right_limit - global_position.x

	# Set the direction based on the larger area
	if right_area > left_area:
		sprite_2d.flip_h = true  # Face right
	else:
		sprite_2d.flip_h = false  # Face left
		


func _on_shoot_timer_timeout() -> void:
	shoot_bullet()
	shoot_timer.start()  # Restart the timer
	
func shoot_bullet():
	# Create a new bullet instance
	if is_on_floor():
		var bullet = bullet_scene.instantiate()
		bullet.position = global_position  # Set bullet position at enemy's position

		# Calculate the direction to the player
		var bullet_direction = (player.global_position - global_position).normalized()

		# Prevent the bullet from shooting upwards by setting the y component to be >= 0
		bullet_direction.y = max(bullet_direction.y, 0)

		bullet.direction = bullet_direction  # Pass direction to the bullet script

		# Add the bullet to the scene
		get_tree().get_root().get_node("World").get_node("enemy_projectile").add_child(bullet)
