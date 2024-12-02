extends Control

# Intervalo entre cada caractere na animação
var _step: float = 0.05
@export var _dialog: RichTextLabel = null  # Referência ao RichTextLabel
var _dialogo_ativo : Node = null  # Armazena o diálogo ativo

# Função que é chamada quando o botão OK é pressionado
func _on_button_pressed() -> void:
	queue_free()  # Remove o diálogo da cena
	_dialogo_ativo = null  # Limpa a referência do diálogo ativo

# Função chamada quando o nó é carregado (Ready)
func _ready() -> void:
	_dialog = $Pista
	_initialize_dialog()

# Função que inicializa o diálogo com a animação do texto
func _initialize_dialog() -> void:
	if not _dialog:
		print("Erro: RichTextLabel não atribuído!")
		return

	#_dialog.visible_characters = 0  # Inicializa com texto oculto

	# Exibe os caracteres do diálogo um por um
	#while _dialog.visible_characters < _dialog.text.length():
	#	await get_tree().create_timer(_step).timeout
		#_dialog.visible_characters += 1
