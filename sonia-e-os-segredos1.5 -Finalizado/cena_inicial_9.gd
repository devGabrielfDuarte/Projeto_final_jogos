extends Node2D

# Intervalo entre cada caractere na animação
var _step: float = 0.05
@export var _dialog: RichTextLabel = null  # Referência ao RichTextLabel

func _ready() -> void:
	MusicMenager.music_player3.stop()
	MusicMenager.music_player.stop()
	$CanvasLayer/Control/Audio.play()
	_dialog = $CanvasLayer/Control/Texto/texto
	_initialize_dialog()
	init_cine()

func init_cine() -> void:
	call_deferred("mudar_para_cena_inicial")	

func _on_button_pressed() -> void:
	print("Botão pressionado. Iniciando troca de cena...")
	call_deferred("_mudar_para_mapa_principal")
	

func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://tela_inicial.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)
	print("Cena trocada para MapaPrincipal!")
	
func _initialize_dialog() -> void:
	if not _dialog:
		print("Erro: RichTextLabel não atribuído!")
		return

	_dialog.visible_characters = 0  # Inicializa com texto oculto
	while _dialog.visible_characters < _dialog.text.length():
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1
