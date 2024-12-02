extends RichTextLabel

# Tempo entre cada rolagem em segundos
var tempo_rolagem: float = 0.1

func _ready():
	# Inicia a função de rolagem automática
	iniciar_rolagem_automatica()

func iniciar_rolagem_automatica():
	# Configura um timer para rolagem automática
	var timer = Timer.new()
	timer.set_wait_time(tempo_rolagem)
	timer.set_one_shot(false)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	# Verifica a rolagem máxima e rola para baixo
	var scroll_container = get_parent()  # Assume que o pai é um ScrollContainer
	if scroll_container:
		if scroll_container.v_scroll.value < scroll_container.v_scroll.max_value:
			scroll_container.v_scroll.value += 1
		else:
			scroll_container.v_scroll.value = 0  # Volta para o topo ao atingir o final
