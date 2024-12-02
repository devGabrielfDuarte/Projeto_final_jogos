extends Node2D

# Configurações
@export var _step: float = 0.05  # Intervalo entre cada caractere na animação



func _ready() -> void:
	$CanvasLayer/Control/AudioStreamPlayer.play()
	GameController.acertos = 0
	return

	


	
func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://cena_inicial.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)
	print("Cena trocada para MapaPrincipal!")


func _on_button_game_over_pressed() -> void:
	print("Botão pressionado. Iniciando troca de cena...")
	call_deferred("_mudar_para_mapa_principal")
	
	
