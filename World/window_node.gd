extends Control

func _ready():
	AppsManager.DroppApp.connect(_dropApp)

func _process(delta):
	if AppsManager.WhoIsGrabbing != null:
		AppsManager.WhoIsGrabbing.global_position = get_global_mouse_position()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event := event as InputEventMouseButton

		# Verifica si fue clic derecho y si se presionó (no al soltar)
		if mouse_event.button_index == MOUSE_BUTTON_LEFT :
			if AppsManager.WhoIsGrabbing == null:
				if  AppsManager.OnMouseEntered != null:
					if mouse_event.pressed:
						AppsManager.WhoIsGrabbing = AppsManager.OnMouseEntered
						AppsManager.WhoIsGrabbing.Dragged = true
						AppsManager.WhoIsGrabbing.mouse_filter = Control.MOUSE_FILTER_IGNORE
					
					
			else:
				if mouse_event.is_released():
					print("LO SOLTASTE")
					AppsManager.WhoIsGrabbing.mouse_filter = Control.MOUSE_FILTER_STOP
					AppsManager.WhoIsGrabbing.Dragged = false
					AppsManager.WhoIsGrabbing = null
				
func _dropApp(WHOWASDROPPED : TextureRect):
	print("OBJETO: ",str(WHOWASDROPPED.NAME) , " WAS DROPPED")
	
	if AppsManager.OnMouseEntered != null:
		print("AL MOMENTO DE SOLTARLO SE DETECTO UNA APP QUE QUIERE CAMBIAR DE POSISION")
		if AppsManager.OnMouseEntered != WHOWASDROPPED:
			print("Cambio de lugar: ", str(WHOWASDROPPED.NAME), " Hacia: ", str(AppsManager.OnMouseEntered.NAME))
			var Ayudante : Control = AppsManager.OnMouseEntered.get_parent()
			AppsManager.OnMouseEntered.Parent = WHOWASDROPPED.Parent
			WHOWASDROPPED.Parent = Ayudante
			AppsManager.OnMouseEntered = null
	elif AppsManager.WhoIsAbove != null:
			print("Entro primero")
			if AppsManager.WhoIsAbove != WHOWASDROPPED.Parent:
				print("Entro Ultimo")
				WHOWASDROPPED.Parent = AppsManager.WhoIsAbove
			else:
				WHOWASDROPPED.global_position = WHOWASDROPPED.Parent.global_position
	else:
		WHOWASDROPPED.global_position = WHOWASDROPPED.Parent.global_position
