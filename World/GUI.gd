extends ColorRect
class_name GUIBUTTONS

enum GUIBUTTONSOPTIONS{
	EXIT,
	MIN,
	MAX,
	Pestaña
}

@export var COlorOverThis : Color
@export var ColorPRESSED : Color
@export var OPTIONSGUIBUTTON : GUIBUTTONSOPTIONS = GUIBUTTONSOPTIONS.EXIT



signal GUIPRESSED(WHO: ColorRect)
signal GUIFINISH(WHO: ColorRect)
signal OverApp(WhoAmI : GUIBUTTONS,SeAgrega : bool)
var OverThis : bool = false

func _ready():
	self.mouse_entered.connect(_mouseEntered)
	self.mouse_exited.connect(_mouseExited)
	self.focus_mode = Control.FOCUS_ALL

func _mouseEntered():
	OverThis = true
	OverApp.emit(self,true)
	self.color = COlorOverThis

func _mouseExited():
	OverThis = false
	OverApp.emit(self,false)
	self.color = Color(1, 1, 1, 1)


				

func _focusEntered():
	self.modulate = ColorPRESSED

func _focusExited():
	print("SALISTE DEL FOCUS")
	if OverThis:
		self.modulate = COlorOverThis
	else:
		self.color = Color(1, 1, 1, 1)
