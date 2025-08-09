extends Sprite2D
class_name MONITOR

@onready var screen = $Screen
@onready var screen_on = $Screen/ScreenOn

@export var BLOCKS : Array[APPSBLOCK]
@onready var h_blocks = %HBlocks

@onready var focus_camera = $"../FocusCamera"
@onready var normal_camera = $"../NormalCamera"


const V_BLOCKS = preload("res://World/v_blocks.tscn")
const APPS_BLOCK = preload("res://World/apps_block.tscn")


@onready var window = %Window
@onready var footer = %Footer
@onready var window_node = $Screen/ScreenOn/VBoxContainer/WindowNode
@onready var footer_node = $Screen/ScreenOn/VBoxContainer/FooterNode

var index := 0

@onready var screen_off = $Screen/ScreenOff
@onready var monitor_area = $MonitorArea
@onready var video_stream_player = $VideoStreamPlayer
@onready var button_computer = $ButtonComputer as PowerButton
signal AllWasCreated(wasCreated : bool, who : ColorRect)
var VWindow : float = 100
var HWindow : float = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	button_computer.ComputadoraEncendida.connect(Encendida)
	video_stream_player.finished.connect(animationFinished)
	VWindow = screen.size.y
	HWindow = screen.size.x
	screen_off.show()
	screen_on.mouse_entered.connect(_mouseEntered)
	screen_on.mouse_exited.connect(_mouseExited)
	self.AllWasCreated.connect(AppsManager._allWasCreated)
	_FORMATEAR()
	

func Encendida(turnOn : bool):
	if(turnOn):
		add_child(screen)
		#Temporal Quitar despues de experimentos
		#video_stream_player.play()
		animationFinished()
	else:
		if video_stream_player.is_playing():
			video_stream_player.stop()
			
		remove_child(screen)

func animationFinished():
	index = 0
	screen_off.hide()

	# Calcula tamaños de ventana
	var result  : float = VWindow * 0.92
	var residuo : float = VWindow - result

	window_node.custom_minimum_size.y = result
	footer_node.custom_minimum_size.y = residuo

	var distance : int = 68 # tamaño total de cada celda
	var width_screen  = HWindow  # ancho de la pantalla
	var height_screen = result   # alto disponible

	# Número de celdas horizontales y verticales
	var cols = int(width_screen / distance)
	var rows = int(height_screen / distance)

	
	_FORMATEAR()
	BLOCKS.clear()
	var numbers : int = 0
	for X in range(cols):
		var newV = V_BLOCKS.instantiate()
		h_blocks.add_child(newV)

		# Si es la última columna, que se expanda horizontalmente
		if X == cols-1:
			newV.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		for y in range(rows):
			var block = APPS_BLOCK.instantiate() 
			newV.add_child(block,true)
			block.Number = numbers
			numbers += 1
			BLOCKS.append(block)
			
			if block.get_children().size() == 0:
				_createApps(block)
			AllWasCreated.emit(true, block)
			#SI QUIERO SABER Y AÑADIR MAS EXPERIENCIA EN CADA CURSOR
			#block.mouse_default_cursor_shape =index
			#index += 1

			# Si es la última fila, que se expanda verticalmente
			if y == rows-1:
				block.size_flags_vertical = Control.SIZE_EXPAND_FILL


func _createApps(fatehr : ColorRect):
	for App in AppsManager.appsNeeded:
		if App != null:
			var AppIntantated = App.instantiate() as APPS
			AppIntantated.Parent = fatehr
			AppIntantated.global_position = fatehr.global_position
			AppIntantated.mouse_entered.connect(_mouseEntered)
			AppIntantated.mouse_exited.connect(_mouseExited)
			AppsManager.ExistentApps.append(AppIntantated)
			AppsManager.appsNeeded.erase(App)
			return

func _FORMATEAR():
	# Limpiar contenido anterior si ya existía
	var Childrens = h_blocks.get_children()
	var howmanyChildren = Childrens.size()
	AppsManager.appsNeeded = AppsManager.AllApps.duplicate(true)
	AppsManager.ExistentApps.clear()
	if howmanyChildren != 0:
		for x in Childrens:
			AllWasCreated.emit(false, x)
			x.mouse_entered.disconnect(_mouseEntered)
			x.mouse_exited.disconnect(_mouseExited)
			x.queue_free()

func _mouseEntered():
	normal_camera.priority = 0
	focus_camera.priority = 100
func _mouseExited():
	normal_camera.priority = 100
	focus_camera.priority = 0
	AppsManager.WhoIsAbove = null
