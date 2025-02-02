extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d: Sprite2D = $Sprite2D
const BULLET = preload("res://scenes/bullet.tscn")
@onready var flash_red_timer: Timer = $FlashRedTimer
@onready var healthbar: ProgressBar = $Healthbar
var hp = 100
#var shoot_direction = Vector2.RIGHT

func _ready():
	healthbar.init_health(hp)
	AutoloadScript.player_hit.connect(flash_red)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	healthbar.health = hp
	mouse_cursor()
	shoot()
	move_and_slide()
	
func mouse_cursor():
	var mouse_position = get_global_mouse_position()

	if mouse_position.x < global_position.x:
		sprite_2d.flip_h = false
	else:
		sprite_2d.flip_h = true

func shoot():
	if Input.is_action_just_pressed("shoot"):
		var bullet = BULLET.instantiate()

		# Get the direction from player to the mouse cursor
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - global_position).normalized()

		bullet.direction = direction  # Pass the calculated direction to the bullet

		var player_position = global_position
		get_tree().get_root().get_node("World").get_node("player_projectile").add_child(bullet)
		bullet.position = player_position

func reset_flash():
	sprite_2d.modulate = Color(1, 1, 1) 

func flash_red():
	#print("flashing red")
	#flash_red_timer.start()
	sprite_2d.modulate = Color(1, 0, 0)  # Change sprite color to red
	flash_red_timer.start()
	#fdlash_red_timer.start() 
		


func _on_flash_red_timer_timeout() -> void:
	sprite_2d.modulate = Color(1, 1, 1)
