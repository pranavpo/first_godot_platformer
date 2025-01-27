extends Node2D

const enemy_scene = preload("res://scenes/enemy.tscn")  # Preload the enemy scene
@onready var enemy_timer: Timer = $EnemyTimer  # Reference to the Timer node
@onready var floor: Node2D = $Floor  # Reference to the Floor node (use the correct node type here)
@onready var player: CharacterBody2D = $Player  # Reference to the Player node

# Spawn area boundaries for X between -80 and 640
var spawn_area_min_x = -80  # Minimum X spawn position
var spawn_area_max_x = 640  # Maximum X spawn position

func _ready():
	# Start the timer to spawn enemies every 0.33 seconds
	enemy_timer.start()  # Set the timer interval to 0.33 seconds

# Function to spawn an enemy at a random position within the spawn area
func spawn_enemy():
	# Get the player's CircleShape2D for the Y position estimation
	var player_collision_shape = player.get_node("CollisionShape2D").shape as CircleShape2D
	var player_radius = player_collision_shape.radius  # Get radius from CircleShape2D
	
	# Get the top of the player's position (Y)
	var player_top_y = player.global_position.y - player_radius
	
	# Get the floor position (Y value of the floor node)
	var floor_y_position = floor.global_position.y
	
	# Define the spawn area for Y (ensure it is above the floor)
	var spawn_area_min_y = max(floor_y_position, player_top_y)  # Ensure spawn min Y is above the floora
	var spawn_area_max_y = spawn_area_min_y - 200  # Adjust this range for better positioning

	# Get a random position within the defined spawn area (X between -80 and 640)
	var random_position = Vector2(
		randf_range(spawn_area_min_x, spawn_area_max_x),  # Random X position between -80 and 640
		randf_range(spawn_area_min_y, spawn_area_max_y)   # Random Y position just above the player
	)
	var enemy = enemy_scene.instantiate()
	enemy.position = random_position
	add_child(enemy)

# Timer timeout signal callback
func _on_enemy_timer_timeout() -> void:
	spawn_enemy()  # Call spawn_enemy every time the timer runs out
