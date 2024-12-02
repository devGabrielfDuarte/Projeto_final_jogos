extends Node2D

# Variáveis e constantes
var dialog_floresta = load("res://dialog_floresta.tscn")  # Exemplo de um diálogo
var pista_atual = ""  # Pista que será mostrada
var tempo_restante: float = 200.0  # Tempo total inicial em segundos
var penalidade_tempo: int = 30  # Penalidade em segundos para cada erro
var dialogo_ativo : Node = null



var locais_tentados = []  # Locais já tentados pelo jogador
var acertos = 0  # Número de acertos do jogador

# Mapeamento de pistas por local (com múltiplas pistas)
var pistas_por_local = {
	"Cachoeira": [
		"A água canta como uma sereia.!",
		"O som das cascatas ecoa pelas pedras.!",
		"Você encontra uma trilha úmida levando à cachoeira.!",
		"O sol reflete no fluxo da água como cristais dançantes.!",
		"Entre as pedras, há marcas de algo arrastado.!",
		"O murmúrio da água esconde segredos do passado.!",
		"Você vê uma trilha de galhos quebrados em direção ao som da cascata.!",
		"Um cheiro de água fresca invade o ar ao se aproximar.!"
	],
	"Floresta": [
		"Você sente um cheiro de folhas úmidas e ouve o som de passos.!",
		"O vento balança as árvores, revelando marcas recentes no solo.!",
		"Você vê pegadas de animais indo para a floresta.!",
		"Uma sombra rápida desaparece entre as árvores.",
		"Você encontra um pedaço de tecido preso em um galho.!",
		"As folhas no chão estão esmagadas, indicando movimento recente.!",
		"O canto dos pássaros para repentinamente, como se algo os assustasse.!",
		"Um rastro de frutas comidas leva a uma clareira.!"
	],
	"Pantanal": [
		"Você encontra pegadas em direção ao Pantanal.!",
		"A lama revela marcas de botas pesadas.!",
		"Um som distante de água parada atrai sua atenção.!",
		"Você escuta o som de sapos, mas um ruído diferente se destaca.!",
		"Pegadas de botas pesadas afundam na lama densa.!",
		"O ar é pesado e úmido, com um leve cheiro de fumaça.!",
		"Marcas de uma embarcação improvisada aparecem perto da água.!",
		"A água parada reflete algo se movendo ao longe.!"
	],
	"Montanha": [
		"O ar rarefeito faz você ouvir seu próprio coração bater.!",
		"Você encontra rochas partidas e pegadas na poeira.!",
		"O calor das pedras dá uma pista.!",
		"Você percebe uma sombra subindo os picos rochosos.!",
		"Há um rastro de pedras desalinhadas no caminho estreito.!",
		"Marcas recentes de escalada estão na parede da rocha.!",
		"O som do vento forte carrega um eco misterioso.!",
		"Um cachecol vermelho está preso em um arbusto próximo ao penhasco.!"
	],
	"Vila": [
		"As pessoas murmuram histórias sobre uma sombra na Vila.!",
		"Uma velha lhe diz que viu alguém misterioso perto da praça.!",
		"Há rumores de movimentos estranhos perto da igreja.!",
		"Uma criança aponta para um beco dizendo que viu algo estranho.!",
		"O cheiro de comida na praça esconde o odor de fumaça distante.!",
		"As janelas de uma casa fechada rangem misteriosamente.!",
		"Um cachorro late incessantemente em direção a um canto escuro.!",
		"Um velho menciona ter ouvido passos à noite no telhado.!"
	]
}

# Locais possíveis
var locais_possiveis = ["Cachoeira", "Floresta", "Pantanal", "Montanha", "Vila"]

# Mapeamento de botões para diálogos
var botoes_para_dialogos = {
	"Cachoeira": load("res://dialog_cachoeira.tscn"),
	"Floresta": load("res://dialog_floresta.tscn"),
	"Pantanal": load("res://dialog_pantanal.tscn"),
	"Montanha": load("res://dialog_montanha.tscn"),
	"Vila": load("res://dialog_vila.tscn")
}


func _ready() -> void:
	
	$CanvasLayer/Control/Audio.play()
	if GameController.local_da_caca == "":
		iniciar_caca()
	#else:
		#print("Local da caça recuperado do autoload:", GameController.local_da_caca)
	atualizar_pista()
	$CanvasLayer/Control/Mapa/TempoLabel.text = "Tempo: " + str(floor(tempo_restante)) + "s"
	$CanvasLayer/Control/Mapa/BotaoEspecial.visible = false
	
	$CanvasLayer/Control/TituloControl/gemas.visible = false
	$CanvasLayer/Control/TituloControl/gemas2.visible = false
	$CanvasLayer/Control/TituloControl/gemas3.visible = false
	$CanvasLayer/Control/TituloControl/gemas4.visible = false
	$CanvasLayer/Control/TituloControl/gemas5.visible = false
	
	set_process(true)
	mostrar_gema()
	mostrar_botao()
	

# Define o local inicial da caça
func iniciar_caca() -> void:
	GameController.local_da_caca = locais_possiveis[randi() % locais_possiveis.size()]
	locais_tentados.clear()
	#print("Local inicial da Caça:", GameController.local_da_caca)

# Atualiza a cada frame
func _process(delta: float) -> void:
	tempo_restante -= delta
	if tempo_restante <= 0:
		tempo_restante = 0
		finalizar_jogo_derrota()
	$CanvasLayer/Control/Mapa/TempoLabel.text = "Tempo: " + str(floor(tempo_restante)) + "s"
	$CanvasLayer/Control/Mapa/ProgressoLabel.text = "Acertos: " + str(floor(GameController.acertos))

# Verifica a escolha do jogador
func verificar_escolha(local_escolhido: String) -> void:
	if local_escolhido == GameController.local_da_caca:
		$CanvasLayer/Control/AudioCorrect.play()
		print("Você acertou! Continue seguindo as pistas.")
		GameController.acertos += 1
		mudar_local_da_caca()
		atualizar_pista()
		if GameController.acertos < 5:
			exibir_dialogo_pista_para_local(local_escolhido, pista_atual)  # Exibe o diálogo correto com a pista
	else:
		print("Você errou! A Caça mudou de lugar.")
		mudar_local_da_caca()
		var pistas_complexas = gerar_pistas_complexas(GameController.local_da_caca)
		exibir_dialogo_pista_para_local(local_escolhido, pistas_complexas[randi() % pistas_complexas.size()])  # Exibe uma pista complexa verdadeira
		reduzir_tempo(penalidade_tempo)
	locais_tentados.append(local_escolhido)
	mostrar_gema()
	mostrar_botao()

# Gera pistas mais complexas, porém verdadeiras, baseadas no local correto
func gerar_pistas_complexas(local: String) -> Array:
	var pistas_complexas = []
	match local:
		"Cachoeira":
			pistas_complexas = [
				"A água canta como uma sereia e você percebe marcas de algo sendo arrastado.",
				"O som das cascatas ecoa pelas pedras, revelando trilhas úmidas que levam mais além.",
				"Entre as pedras, há marcas de algo arrastado e o sol reflete no fluxo da água como cristais dançantes."
			]
		"Floresta":
			pistas_complexas = [
				"Você sente um cheiro de folhas úmidas e percebe marcas de passos misturadas com pegadas de animais.",
				"O vento balança as árvores, revelando não só marcas recentes no solo, mas também um pedaço de tecido preso em um galho.",
				"As folhas no chão estão esmagadas, e um rastro de frutas comidas leva a uma clareira próxima."
			]
		"Pantanal":
			pistas_complexas = [
				"A lama revela marcas de botas pesadas e um som distante de água parada atrai sua atenção.",
				"Você escuta o som de sapos, mas um ruído diferente se destaca, junto com pegadas de botas pesadas afundadas na lama.",
				"O ar é pesado e úmido, com um leve cheiro de fumaça, e marcas de uma embarcação improvisada aparecem perto da água."
			]
		"Montanha":
			pistas_complexas = [
				"O ar rarefeito faz você ouvir seu próprio coração bater, enquanto observa rochas partidas e pegadas na poeira.",
				"Você percebe uma sombra subindo os picos rochosos e há um rastro de pedras desalinhadas no caminho estreito.",
				"Marcas recentes de escalada estão na parede da rocha e o som do vento forte carrega um eco misterioso."
			]
		"Vila":
			pistas_complexas = [
				"As pessoas murmuram histórias sobre uma sombra na Vila e uma velha lhe diz que viu alguém misterioso perto da praça.",
				"O cheiro de comida na praça esconde o odor de fumaça distante, e as janelas de uma casa fechada rangem misteriosamente.",
				"Um cachorro late incessantemente em direção a um canto escuro, enquanto um velho menciona ter ouvido passos à noite no telhado."
			]
	return pistas_complexas

# Mostra o botão especial após 3 acertos
func mostrar_botao() -> void:
	if GameController.acertos == 5:
		$CanvasLayer/Control/Mapa/BotaoEspecial.visible = true
		$CanvasLayer/Control/Mapa/Floresta.visible = false
		$CanvasLayer/Control/Mapa/Vila.visible = false
		$CanvasLayer/Control/Mapa/Pantanal.visible = false
		$CanvasLayer/Control/Mapa/Montanha.visible = false
		$CanvasLayer/Control/Mapa/Cachoeira.visible = false
		
	
var ultimo_acertos = 0  # Variável para rastrear o último valor de acertos

func mostrar_gema() -> void:
	# Verifica se houve incremento na variável 'GameController.acertos'
	if GameController.acertos > ultimo_acertos:
		ultimo_acertos = GameController.acertos  # Atualiza o último valor

		# Exibe a gema correspondente com base no número de acertos
		if GameController.acertos == 1:
			$CanvasLayer/Control/TituloControl/gemas.visible = true
			$CanvasLayer/Control/TituloControl/gemas2.visible = false
			$CanvasLayer/Control/TituloControl/gemas3.visible = false
			$CanvasLayer/Control/TituloControl/gemas4.visible = false
			$CanvasLayer/Control/TituloControl/gemas5.visible = false
			exibir_mensagem1()

		elif GameController.acertos == 2:
			$CanvasLayer/Control/TituloControl/gemas.visible = true
			$CanvasLayer/Control/TituloControl/gemas2.visible = true
			$CanvasLayer/Control/TituloControl/gemas3.visible = false
			$CanvasLayer/Control/TituloControl/gemas4.visible = false
			$CanvasLayer/Control/TituloControl/gemas5.visible = false
			exibir_mensagem2()

		elif GameController.acertos == 3:
			$CanvasLayer/Control/TituloControl/gemas.visible = true
			$CanvasLayer/Control/TituloControl/gemas2.visible = true
			$CanvasLayer/Control/TituloControl/gemas3.visible = true
			$CanvasLayer/Control/TituloControl/gemas4.visible = false
			$CanvasLayer/Control/TituloControl/gemas5.visible = false
			exibir_mensagem3()
			

		elif GameController.acertos == 4:
			$CanvasLayer/Control/TituloControl/gemas.visible = true
			$CanvasLayer/Control/TituloControl/gemas2.visible = true
			$CanvasLayer/Control/TituloControl/gemas3.visible = true
			$CanvasLayer/Control/TituloControl/gemas4.visible = true
			$CanvasLayer/Control/TituloControl/gemas5.visible = false
			exibir_mensagem4()

		elif GameController.acertos == 5:
			$CanvasLayer/Control/TituloControl/gemas.visible = true
			$CanvasLayer/Control/TituloControl/gemas2.visible = true
			$CanvasLayer/Control/TituloControl/gemas3.visible = true
			$CanvasLayer/Control/TituloControl/gemas4.visible = true
			$CanvasLayer/Control/TituloControl/gemas5.visible = true
			exibir_mensagem5()
			



func exibir_mensagem_cuca() -> void:
	var dialog_scene = load("res://dialog_cuca.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))

func exibir_mensagem1() -> void:
	var dialog_scene = load("res://dialog_gema_1.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))

func exibir_mensagem2() -> void:
	var dialog_scene = load("res://dialog_gema_2.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))

func exibir_mensagem3() -> void:
	var dialog_scene = load("res://dialog_gema_3.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))

func exibir_mensagem4() -> void:
	var dialog_scene = load("res://dialog_gema_4.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))

func exibir_mensagem5() -> void:
	var dialog_scene = load("res://dialog_gema_5.tscn").instantiate()
	$CanvasLayer.add_child(dialog_scene)
	if dialog_scene.has_node("BotaoOK"):
		var botao_ok = dialog_scene.get_node("BotaoOK") as Button
		botao_ok.connect("pressed", Callable(self, "_on_dialog_ok_pressed").bind(dialog_scene))
		


		
		
# Atualiza a pista com uma pista aleatória do local da caça
func atualizar_pista() -> void:
	var pistas = pistas_por_local[GameController.local_da_caca]
	pista_atual = pistas[randi() % pistas.size()]
	

	

# Exibe o diálogo correto com a pista e uma mensagem de boas-vindas personalizada
func exibir_dialogo_pista_para_local(local: String, texto: String) -> void:
	if local in botoes_para_dialogos:
		var dialog_scene = botoes_para_dialogos[local].instantiate()
		$CanvasLayer.add_child(dialog_scene)  # Adiciona a cena do diálogo
		if dialog_scene.has_node("Pista"):  # Verifica se o nó 'pista' existe
			var pista_label = dialog_scene.get_node("Pista") as RichTextLabel
			var mensagem_boas_vindas = get_mensagem_boas_vindas(local)
			pista_label.text = mensagem_boas_vindas + " " + texto   # Adiciona a mensagem de boas-vindas antes da pista
			dialog_scene.animar_texto_com_audio(pista_label, pista_label.text, 0.05)
			  # Anima o texto letra por letra
		else:
			print("Erro: Nó 'pista' não encontrado no diálogo do local:", local)
	else:
		print("Erro: Nenhum diálogo associado ao local:", local)

# Retorna a mensagem de boas-vindas personalizada com base no local
func get_mensagem_boas_vindas(local: String) -> String:
	match local:
		"Cachoeira":
			return "Bem-vindo à cachoeira! Deixe-me lhe ajudar com uma pista:"
		"Floresta":
			return "Bem-vindo à floresta amazônica! Eu sou o Curupira e vou lhe ajudar com uma pista:"
		"Pantanal":
			return "Bem-vindo ao Pantanal! Vou lhe ajudar com uma pista:"
		"Montanha":
			return "Bem-vindo às montanhas! Vamos descobrir a pista juntos:"
		"Vila":
			return "Bem-vindo à vila! Aqui está uma pista para você:"
		_:
			return "Bem-vindo! Aqui está uma pista para você:"

# Reduz o tempo restante
func reduzir_tempo(valor: int) -> void:
	tempo_restante -= valor
	if tempo_restante <= 0:
		finalizar_jogo_derrota()

# Move a caça para um novo local aleatório
func mudar_local_da_caca() -> void:
	var novos_locais = locais_possiveis.duplicate()
	novos_locais.erase(GameController.local_da_caca)
	if novos_locais.size() > 0:
		GameController.local_da_caca = novos_locais[randi() % novos_locais.size()]
		#print("Novo local da Caça:", GameController.local_da_caca)

# Função de vitória
func finalizar_jogo_vitoria() -> void:
	get_tree().change_scene_to_file("res://TelaVitoria.tscn")
	
func init_cine() -> void:
	call_deferred("mudar_para_cena_inicial")

func mudar_para_cena_inicial() -> void:
	get_tree().change_scene_to_file("res://cena_inicial.tscn")


# Função de derrota
func finalizar_jogo_derrota() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")
	
# Ação dos botões
func _on_cachoeira_pressed() -> void:
	verificar_escolha("Cachoeira")

func _on_floresta_pressed() -> void:
	verificar_escolha("Floresta")

func _on_pantanal_pressed() -> void:
	verificar_escolha("Pantanal")

func _on_montanha_pressed() -> void:
	verificar_escolha("Montanha")

func _on_vila_pressed() -> void:
	verificar_escolha("Vila")
	
func _mudar_para_mapa_principal() -> void:
	var scene_path = "res://dialog_cuca.tscn"
	if not FileAccess.file_exists(scene_path):
		print("Erro: Cena não encontrada no caminho:", scene_path)
		return
	get_tree().change_scene_to_file(scene_path)	

# Botão especial


func animar_texto(label: RichTextLabel, texto: String, intervalo: float) -> void:
	label.visible_characters = 0  # Inicia sem texto visível
	for i in range(texto.length()):
		await get_tree().create_timer(intervalo).timeout  # Aguarda o tempo definido
		#label.visible_characters += 1  # Exibe mais um caractere
		

	


func _on_botao_especial_pressed() -> void:
	print("Botão pressionado. Iniciando troca de cena...")
	call_deferred("_mudar_para_mapa_principal")
