extends Node2D

# Configurações
@export var _step: float = 0.05  # Intervalo entre cada caractere na animação
@export var _dialog: RichTextLabel = null  # Referência ao RichTextLabel

# Nó de áudio para som de digitação
@onready var audio_player = $CanvasLayer/Control/Texto/Digitacao

func _ready() -> void:
	# Inicializa o RichTextLabel e anima o texto com som
	MusicMenager.music_player2.stop()
	MusicMenager.music_player3.play()
	_dialog = $CanvasLayer/Control/Texto/texto  # Certifique-se de ajustar o caminho
	_initialize_dialog()
	animar_texto_com_audio(_dialog, _dialog.text, _step)  # Chama a animação do texto
	init_cine()

func init_cine() -> void:
	call_deferred("mudar_para_cena_inicial")	

func _on_button_pressed() -> void:
	print("Botão pressionado. Iniciando troca de cena...")
	call_deferred("_mudar_para_mapa_principal")
	
func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://cena_final_2.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)
	print("Cena trocada para MapaPrincipal!")

# Função para animar o texto com som
func animar_texto_com_audio(label: RichTextLabel, texto: String, intervalo: float) -> void:
	label.visible_characters = 0  # Inicia sem texto visível
	for i in range(texto.length()):
		await get_tree().create_timer(intervalo).timeout  # Aguarda o intervalo definido
		label.visible_characters += 1  # Mostra mais um caractere

		# Reproduz o som de digitação
		if not audio_player.playing:  # Evita sobreposição de sons
			audio_player.play()

	# Opcional: Para o som ao final da digitação
	audio_player.stop()

func _initialize_dialog() -> void:
	if not _dialog:
		print("Erro: RichTextLabel não atribuído!")
		return

	_dialog.visible_characters = 0  # Inicializa com texto oculto