extends CanvasLayer

# Le dice al 'Main' node que el botón fue presionado
signal start_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Fin del juego")
	# Espera hasta que el timer se complete.
	await $MessageTimer.timeout
	
	$Message.text = "¡Evita a los monstruos!"
	$Message.show()
	
	# Haciendo un One-shot Timer y esperamos a que se complete.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()

func update_score(score):
	$ScoreLabel.text = str(score)
	

func _on_start_button_pressed() -> void:
	$StartButton.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
