extends Area2D
signal hit

@export var speed = 400 # Que tan rápido se mueve el player
var screen_size # Tamaño de la pantalla

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta: float):
	var velocity = Vector2.ZERO # Vector de movimiento del player
	
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y < 0


func _on_body_entered(body: Node2D):
	hide() # Player desaparece al ser tocado
	hit.emit()
	# Desactivamos las colisiones de player para no seguir emitiendo la hit señal 
	$CollisionShape2D.set_deferred("disabled", true)
	
# Resetear al player al iniciar la partida
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
