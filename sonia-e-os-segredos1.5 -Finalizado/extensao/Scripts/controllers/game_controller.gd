extends Node

@export var quiz: QuizTheme
@export var color_right: Color
@export var color_wrong: Color

var buttons: Array[Button]
var index: int  
var correct: int
var count: int
@onready var question_texts: Label = $Content/ColorRect/QuestionText
@onready var question_image: TextureRect = $Content/QuestionInfo/ImageHolder/QuestionImage
@onready var question_video: VideoStreamPlayer = $Content/QuestionInfo/ImageHolder/QuestionVideo
@onready var image_holder: Panel = $Content/QuestionInfo/ImageHolder
@onready var question_audio: AudioStreamPlayer = $Content/QuestionInfo/ImageHolder/QuestionAudio

func _ready() -> void:
	for button in $Content/QuestionHolder.get_children():
		buttons.append(button)
	$AudioStreamPlayer.play()
	load_quiz()

func load_quiz() -> void:
	if not quiz:
		print("Erro: quiz não foi inicializado.")
		return
	
	if not quiz.theme:
		print("Erro: quiz.theme está vazio ou não foi configurado.")
		return

	if index >= quiz.theme.size():
		_game_over()
		return

	question_texts.text = quiz.theme[index].question_info

	var options = quiz.theme[index].options

	for i in range(buttons.size()):
		buttons[i].text = options[i]
		buttons[i].pressed.connect(_buttons_answer.bind(buttons[i]))

	match quiz.theme[index].type:
		Enum.QuestionType.TEXT:
			$Content/QuestionInfo/ImageHolder.show()
				
		Enum.QuestionType.IMAGE:
			$Content/QuestionInfo/ImageHolder.show()
			question_image.texture = quiz.theme[index].question_image
				
		Enum.QuestionType.VIDEO:
			$Content/QuestionInfo/ImageHolder.show()
			question_video.stream = quiz.theme[index].question_video
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
		count += 1
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
		
func _game_over() -> void:
	print("FIM")
	print(count)        
	
	if count > 1:
		index = 0  # Reinicia o índice das perguntas
		count = 0  # Opcional: também redefinir o contador de respostas corretas
		print("Reiniciando o quiz...")
		load_quiz()  # Recarrega o quiz
	else:
		print("Fim do jogo! Não atingiu a pontuação mínima.")
