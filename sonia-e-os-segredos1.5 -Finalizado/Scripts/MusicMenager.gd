extends Node

var music_player: AudioStreamPlayer  # Declara o nó para o player de música
var music_player2: AudioStreamPlayer
var music_player3: AudioStreamPlayer

func _ready():
	# Cria e adiciona o nó AudioStreamPlayer à cena
	music_player = AudioStreamPlayer.new()
	music_player2 = AudioStreamPlayer.new()
	music_player3 = AudioStreamPlayer.new()
	add_child(music_player)
	add_child(music_player2)
	add_child(music_player3)
	
	
	if music_player and music_player.playing:
		music_player.stop()
		print("Música parada na cena 4.")

	# Carrega o recurso de áudio
	var audio_stream = load("res://assets/sound/Música Relaxante_ Flauta Indígena e Sons da Natureza - Acalmar a Mente e Relaxar_fQvwNbj1hiI_[cut_1334sec].ogg")  # Certifique-se de usar o caminho correto do arquivo
	
	# Verifica se o recurso foi carregado corretamente
	if audio_stream is AudioStream:
		music_player.stream = audio_stream  # Atribui o recurso de áudio ao player
		print("Áudio carregado com sucesso!")
	else:
		push_error("Erro: O recurso carregado não é do tipo AudioStream!")
		return  # Se não for o tipo correto, retorna e não prossegue

	# Configura o volume do player (0 dB é o volume padrão)
	music_player.volume_db = 0  # Pode ajustar para valores como -10 dB para volume mais baixo ou +5 dB para mais alto

	# Desabilite autoplay e loop para testar sem eles
#	music_player.autoplay = false  # Não começa automaticamente
#	music_player.loop = false      # Não repete a música

	

	# Carrega o recurso de áudio
	var audio_stream2 = load("res://assets/sound/cucacena.mp3")  # Certifique-se de usar o caminho correto do arquivo
	
	# Verifica se o recurso foi carregado corretamente
	if audio_stream2 is AudioStream:
		music_player2.stream = audio_stream2  # Atribui o recurso de áudio ao player
		print("Áudio carregado com sucesso!")
	else:
		push_error("Erro: O recurso carregado não é do tipo AudioStream!")
		return  # Se não for o tipo correto, retorna e não prossegue
		
	var audio_stream3 = load("res://assets/sound/cenafinal.mp3")  # Certifique-se de usar o caminho correto do arquivo
	
	if audio_stream3 is AudioStream:
		music_player3.stream = audio_stream3  # Atribui o recurso de áudio ao player
		print("Áudio carregado com sucesso!")
	else:
		push_error("Erro: O recurso carregado não é do tipo AudioStream!")
		return  # Se não for o tipo correto, retorna e não prossegue
	# Configura o volume do player (0 dB é o volume padrão)
	music_player.volume_db = 0  
	music_player2.volume_db = 0 	
