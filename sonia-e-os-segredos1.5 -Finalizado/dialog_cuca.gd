extends Node2D

# Intervalo entre cada caractere na animação
var _step: float = 0.05
@export var _dialog: RichTextLabel = null  # Referência ao RichTextLabel
@onready var audio_player = $CanvasLayer/Control/Control/Digitacao

func _ready() -> void:
	_dialog = $CanvasLayer/Control/Control/Pista
	_initialize_dialog()
	animar_texto_com_audio(_dialog, _dialog.text, _step)
	init_cine()

func init_cine() -> void:
	call_deferred("mudar_para_cena_inicial")
	MusicMenager.music_player2.play()	

func _on_button_pressed() -> void:
	#GameController.count +=1
	print("Botão pressionado. Iniciando troca de cena...")
	get_tree().change_scene_to_file("res://extensao/scenes/main.tscn")
	#if GameController.count == 1:
		#MusicMenager.music_player.stop()
	

func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://extensao/scenes/main.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)
	print("Cena trocada para MapaPrincipal!")
	
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
	
