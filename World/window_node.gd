extends Control
class_name WINDOWNODE

@onready var screen = $"../../.."
var lasSaveMousePosition : Vector2 = Vector2.ZERO

var isMouMoving : bool = false

signal  OpenApp(WhichApp : APPS, SIZESCREEN : Vector2)

func _ready():
	AppsManager.DroppApp.connect(_dropApp)


func _process(delta):
	#Esto sirve para que la App ya agarrada se ponga en la posicion del mouse
	if AppsManager.WhoIsGrabbing != null:
		AppsManager.WhoIsGrabbing.global_position = get_global_mouse_position()
	
	#Esto sirve para saber si al hacer click se movio lo suficiente para que cuente como si quisieras mover la App
	if lasSaveMousePosition.distance_to(get_global_mouse_position()) > 20 and lasSaveMousePosition != Vector2.ZERO:
		isMouMoving = true
		print("DEBERIA DE MOVERSE")
		if AppsManager.WhoIsGrabbing == null  and AppsManager.WhoPressed != null:
			print("MOVIENDOSE")
			AppsManager.WhoIsGrabbing = AppsManager.WhoPressed
			AppsManager.WhoPressed.z_index = 1000
			AppsManager.WhoIsGrabbing.Dragged = true
			AppsManager.WhoIsGrabbing.mouse_filter = Control.MOUSE_FILTER_IGNORE
			_ChangeCurosrShape(Input.CURSOR_BUSY)
			lasSaveMousePosition = Vector2.ZERO


func _input(event):
	
	#Esto es cuando una app de la ventana del "window" este en el foco
	#Se pone en el foco cuando le aprietas y el codigo esta a continuacion
	var nodo_con_focus = get_viewport().gui_get_focus_owner()
	if nodo_con_focus is APPS:
		if event.is_action_pressed("OpenFocus"):
			print("SE ABRIO LA APP con focus")
			OpenApp.emit(nodo_con_focus,Vector2(screen.size.x,screen.size.y))
			nodo_con_focus.release_focus()
			lasSaveMousePosition = Vector2.ZERO
			AppsManager.WhoPressed = null
	
	#Aqui se haze todo los cliclks y la inteligensia (Solo de la ventana de "windows")
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton

		# Verifica si fue clic derecho y si se presionó (no al soltar)
		if mouse_event.button_index == MOUSE_BUTTON_LEFT :
			if AppsManager.WhoIsGrabbing == null:
				if  AppsManager.OnMouseEntered != null:
					if AppsManager.WhoPressed != null:
						#Esto esta cuando le aprietas por segunda vez a una App
						if mouse_event.pressed :
							#Esto es cuando la app que apretastes anteriormente y la que apretastes ahora son las mismas
							if AppsManager.WhoPressed == AppsManager.OnMouseEntered:
								print("SE ABRIO LA APP")
								OpenApp.emit(AppsManager.WhoPressed,Vector2(screen.size.x,screen.size.y))
								AppsManager.WhoPressed = null
								lasSaveMousePosition = Vector2.ZERO
								
							#Si no son las mismas que aprietastes entonces se cambia todo hace la segunda
							else:
								print("Intentaste Abrir otra app")
								AppsManager.WhoPressed.release_focus()
								AppsManager.WhoPressed = AppsManager.OnMouseEntered
								AppsManager.WhoPressed.grab_click_focus()
								lasSaveMousePosition = get_global_mouse_position()
					
					#Esto es cuando le apretas a una App por primera vez
					elif mouse_event.pressed:
						AppsManager.OnMouseEntered.grab_click_focus()
						AppsManager.WhoPressed = AppsManager.OnMouseEntered
						lasSaveMousePosition = get_global_mouse_position()
					
			#Solo se activa si tienes algo en la mano y soltastes el click
			else:
				if mouse_event.is_released()  :
					lasSaveMousePosition = Vector2.ZERO
					AppsManager.WhoIsGrabbing.mouse_filter = Control.MOUSE_FILTER_STOP
					AppsManager.WhoIsGrabbing.Dragged = false
					AppsManager.WhoIsGrabbing.release_focus()
					AppsManager.WhoIsGrabbing = null
					AppsManager.WhoPressed = null
					isMouMoving = false


#Esto pasa al soltar la app que tenias previamente aggarando
func _dropApp(WHOWASDROPPED : TextureRect):
	_ChangeCurosrShape(Input.CURSOR_ARROW)
	print("LO SOLTASTE")
	if AppsManager.OnMouseEntered != null:
		if AppsManager.OnMouseEntered != WHOWASDROPPED:
			var Ayudante : Control = AppsManager.OnMouseEntered.get_parent()
			AppsManager.OnMouseEntered.Parent = WHOWASDROPPED.Parent
			WHOWASDROPPED.Parent = Ayudante
			AppsManager.OnMouseEntered = null
	elif AppsManager.WhoIsAbove != null:
			if AppsManager.WhoIsAbove != WHOWASDROPPED.Parent:
				WHOWASDROPPED.Parent = AppsManager.WhoIsAbove
			else:
				WHOWASDROPPED.global_position = WHOWASDROPPED.Parent.global_position
	else:
		WHOWASDROPPED.global_position = WHOWASDROPPED.Parent.global_position

#Esto es una funcion para cambiar y añadir dinamismo a las Apps
func _ChangeCurosrShape(cursor_name: Input.CursorShape):
	Input.set_default_cursor_shape(cursor_name)
	screen.mouse_default_cursor_shape = cursor_name
