extends ColorRect

var ALLGUIBUTTONS : Array[GUIBUTTONS]: set = _allGuiButtons
@export var IsMax : bool = false : set = _IsMax
var WhichAppEnteredArray : Array[GUIBUTTONS]
var AppOver : GUIBUTTONS = null
@export var isAPage : bool = false
func _ready():
	ALLGUIBUTTONS = _findAllsPestañas()

func _findAllsPestañas(Parent : Control = self) -> Array[GUIBUTTONS]:
	var helperArray : Array[GUIBUTTONS]
	var AllBabys = Parent.get_children(true)
	if AllBabys.size() != 0:
		for ChildButtons in AllBabys:
			if ChildButtons is GUIBUTTONS:
				print("QUE")
				helperArray.append(ChildButtons)
			helperArray += _findAllsPestañas(ChildButtons)
	return helperArray


func _MAX(WHO: ColorRect):
	print("SE HIZO UN MAX")
	IsMax = !IsMax

func _EXIT(WHO: ColorRect):
	self.queue_free()
	
func _IsMax(NewMax : bool):
	IsMax = NewMax
	print("CAMBIO DE MAX")
	if NewMax:
		print("PANTALLA COMPLETA")
	else:
		print("PANTALLA INCOMPLETA")

func _allGuiButtons(NewAllGuiButtons: Array[GUIBUTTONS]):
	ALLGUIBUTTONS = NewAllGuiButtons
	print("NewGuiButtons")
	for GuiButton in NewAllGuiButtons:
		if !GuiButton.is_connected(GuiButton.name,_ComprobarQuienEstaArriba ):
			GuiButton.OverApp.connect(_ComprobarQuienEstaArriba)
		if GuiButton.OPTIONSGUIBUTTON == GuiButton.GUIBUTTONSOPTIONS.MAX:
			if !GuiButton.is_connected(GuiButton.name,_MAX ):
				print("Este: ", str(GuiButton) , " Ya tena el llamado")
				GuiButton.GUIFINISH.connect(_MAX)
		elif GuiButton.OPTIONSGUIBUTTON == GuiButton.GUIBUTTONSOPTIONS.EXIT:
			GuiButton.GUIFINISH.connect(_EXIT)

func _input(event):
	var nodo_con_focus = get_viewport().gui_get_focus_owner()
	if nodo_con_focus is GUIBUTTONS:
		pass
	if AppOver != null:
		if event is InputEventMouseButton:
			var mouse_event : InputEvent = event as InputEventMouseButton
			if mouse_event.button_index == MOUSE_BUTTON_LEFT :
				if mouse_event.pressed:
					self.grab_click_focus()
				elif event.is_released():
					AppOver.GUIFINISH.emit(self)
					self.release_focus()
					print("HACES ESTA ACCION")


func _ComprobarQuienEstaArriba(WhoAmI : GUIBUTTONS,SeAgrega : bool):
	if SeAgrega:
		WhichAppEnteredArray.append(WhoAmI)
	else:
		WhichAppEnteredArray.erase(WhoAmI)
	
	if WhichAppEnteredArray.size() == 0:
		AppOver = null
	else:
		if SeAgrega:
			AppOver = WhoAmI
		else:
			AppOver = WhichAppEnteredArray.back()
