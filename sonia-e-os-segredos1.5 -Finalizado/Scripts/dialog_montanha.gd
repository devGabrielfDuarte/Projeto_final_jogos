extends Control

@onready var audio_player = $Digitacao  # Áudio de digitação
@export var _step: float = 0.05  # Intervalo entre os caracteres

func _on_button_pressed() -> void:
	queue_free()  # Remove o diálogo da cena
	

# Função para animar o texto com áudio e parar quando encontrar "!"
func animar_texto_com_audio(label: RichTextLabel, texto: String, intervalo: float) -> void:
	label.visible_characters = 0  # Inicia sem texto visível
	for i in range(texto.length()):
		await get_tree().create_timer(intervalo).timeout  # Aguarda o intervalo definido
		label.visible_characters += 1  # Mostra mais um caractere

		# Verifica se o caractere exibido é "!" e para o áudio
		if texto[i] == ".":
			print("Caractere '.' encontrado. Parando áudio.")
			audio_player.stop()  # Para o som imediatamente
			break  # Sai do loop para não continuar tocando o som

		# Reproduz o som de digitação
		if not audio_player.playing:  # Evita sobreposição de sons
			audio_player.play()

	# Após o loop, garante que o áudio pare se não houver "!" encontrado
	if audio_player.playing:
		audio_player.stop()
