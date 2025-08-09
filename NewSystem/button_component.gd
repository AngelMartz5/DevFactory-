extends Control
class_name BUTTONCOMPONENT

@export var AppOwner : APPNEW
@onready var color_button = $ColorButton
@export var RemplazarColor : bool = false
var myOriginalColor : Color 
@export var ColorFocus : Color = Color(1,1,1,0.75)
@export var ColorPressed : Color = Color(1,1,1,0.5)
@export var DobleClickToDO : bool = false
var Father : Node
@export var clicked : bool = false
@export var canBeOpen : bool = false

var hasMoved: bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	self.gui_input.connect(_guiInput)
	self.focus_entered.connect(_focusEntered)
	self.focus_exited.connect(_focusExited)
	self.focus_mode = Control.FOCUS_ALL
	myOriginalColor = color_button.color
	Father = self.get_parent()
	if Father != null:
		print("Hay y es: ", str(Father))
		await Father.ready
		if Father is DRAGCOMPONENT:
			print("ENTRO2")
			DobleClickToDO = true
			Father.CanMov.connect(_CanMove)
			Father.QuitMov.connect(_quitMov)
	if !DobleClickToDO:
		self.mouse_entered.connect(_mouseEntered)
		self.mouse_exited.connect(_mouseExited)
	
	if !RemplazarColor:
		ColorFocus = Color(color_button.color.r,color_button.color.g,color_button.color.b,ColorFocus.a)
		ColorPressed = Color(color_button.color.r,color_button.color.g,color_button.color.b,ColorPressed.a)

func _guiInput(event):
	if event is InputEventMouseButton:
		var mouse_event : InputEvent = event as InputEventMouseButton
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.is_pressed() and canBeOpen:
				color_button.color = ColorPressed
			if mouse_event.is_released():
				if DobleClickToDO:
					if canBeOpen:
						_OpenApp()
					elif !hasMoved:
						canBeOpen = true 
						self.grab_focus()
				else:
					_OpenApp()
			hasMoved = false


func _focusEntered():
	_onFocus()
func _focusExited():
	
	color_button.color = myOriginalColor


func _mouseEntered():
	pass
func _mouseExited():
	pass


func _OpenApp():
	_closeAll()
	print("SE Abre App")

func _closeAll():
	self.release_focus()
	canBeOpen = false

func _onFocus():
	color_button.color = ColorFocus


func _CanMove():
	_closeAll()
	hasMoved = true
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
func _quitMov():
	self.mouse_filter = Control.MOUSE_FILTER_PASS
