extends Node

@export var mob_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	# new_game()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func game_over():
	# Detener temporizadores al terminar el juego
	$ScorerTimer.stop()
	$MobTimer.stop()
	
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()

func new_game():
	# Reiniciar el puntaje y colocar al jugador en la posición de inicio
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
		
	get_tree().call_group("mobs", "queue_free")
	
	$HUD.update_score(score)
	$HUD.show_message("Prepárate...")
	$Music.play()

func _on_start_timer_timeout() -> void:
	# Iniciar temporizadores después de la cuenta regresiva de inicio
	$MobTimer.start()
	$ScorerTimer.start()

func _on_mob_timer_timeout() -> void:
	# Crear nueva instancia de la escena Mob
	var mob = mob_scene.instantiate()
	
	# Escoger ubicación random en Path2D
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Posiciona al mob en el punto de aparición.
	mob.position = mob_spawn_location.position
	
	# Calculando dirección en base a la rotación del punto de aparición, ajustada 90°.
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Ajustando la dirección en la que el mob debe moverse (con variación aleatoria incluida).
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Velocidad para el mob 
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawneando el mob
	add_child(mob)

func _on_scorer_timer_timeout() -> void:
	# Incrementar el puntaje con el paso del tiempo
	score += 1
	$HUD.update_score(score)
