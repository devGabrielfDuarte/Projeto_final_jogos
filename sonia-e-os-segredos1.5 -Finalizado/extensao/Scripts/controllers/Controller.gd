extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int  
var correct: int
var count: int = 0

@onready var question_texts: Label = $Content/ColorRect/QuestionText
@onready var question_image: TextureRect = $Content/QuestionInfo/ImageHolder/QuestionImage
@onready var question_video: VideoStreamPlayer = $Content/QuestionInfo/ImageHolder/QuestionVideo
@onready var image_holder: Panel = $Content/QuestionInfo/ImageHolder
@onready var question_audio: AudioStreamPlayer = $Content/QuestionInfo/ImageHolder/QuestionAudio

func _ready() -> void:
	for button in $Content/QuestionHolder.get_children():
		buttons.append(button)
	quiz = preload("res://extensao/resources/folclore/Sonia.tres")
	randomize_array(quiz.theme)
	#$Content/gameover/AudioStreamPlayer.play()
	load_quiz()
			
func load_quiz() -> void:
		
		if index > 5:
			_game_over()
			return
		_check_phase_completion()			
		
		question_texts.text = quiz.theme[index].question_info
		
		var options = quiz.theme[index].options
		
		for i in buttons.size():
			buttons[i].text = options[i]
			buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))
			
		match quiz.theme[index].type:
			Enum.QuestionType.TEXT:
				$Content/QuestionInfo/ImageHolder.show()
				
			#Enum.QuestionType.IMAGE:
				
				#$Content/QuestionInfo/ImageHolder.show()
				#question_image.texture = quiz.theme[index].question_image	
				
			Enum.QuestionType.VIDEO:
				$Content/QuestionInfo/ImageHolder.show()
				question_video.stream = quiz.there[index].question_video
				question_video.play()
				
			Enum.QuestionType.AUDIO:
				$Content/QuestionInfo/ImageHolder.show()
				question_image.texture = quiz.theme[index].question_image	
				question_audio.stream = quiz.theme[index].question_audio
				question_audio.play()	
				
		
			
			
func _buttons_answer(button) -> void:
	if quiz.theme[index].correct == button.text:
		button.modulate = color_right
		$AudioCorrect.play()
		count +=1
	else:
		button.modulate = color_wrong
		$AudioIncorrect.play()
	
	_next_question()	
		
func _next_question() -> void:
	for bt in buttons:
		bt.pressed.disconnect(_buttons_answer)
		
	await get_tree().create_timer(1).timeout
	for bt in buttons:
		bt.modulate = Color.WHITE
	
	question_audio.stop()
	question_video.stop()
	question_audio.stream = null
	question_video.stream = null	
	
	index += 1
	load_quiz()		
	
func _check_phase_completion() -> void:
	
	if count == 3:
		get_tree().change_scene_to_file("res://dialog_cuca_2.tscn")	
		count = 0

func randomize_array(array:Array) -> Array:
	var array_temp = array
	array_temp.shuffle()
	return array_temp	
		

		
func _game_over() -> void:
	# Finaliza o jogo e reinicia variáveis
	$Content/gameover.show()
	MusicMenager.music_player2.stop()
	$Content/gameover/AudioStreamPlayer.play()
	GameController.acertos = 0
	
	return
	#$Content/GameOver/Score.text = str(correct, "/", current_quiz.theme.size())

	

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_button_game_over_pressed() -> void:
	print("Botão pressionado. Iniciando troca de cena...")
	call_deferred("_mudar_para_mapa_principal")
	
func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://cena_inicial.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)
	print("Cena trocada para MapaPrincipal!")
