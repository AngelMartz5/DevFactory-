extends Control
class_name DRAGCOMPONENT

@export var AppOwner : APPNEW
@export var WhoShouldIDrag : Node 
var Dragg : Node
@export var DistanceToActivate : float = 100
var clicking : bool = false
@export var Movement : bool = false
@export var QuitAfterReleas : bool = false
@export var TrowAt : APPSMANAGER.KINDSAPPS
var PositionClicked : Vector2 = Vector2.ZERO
var DragOffset : Vector2 = Vector2.ZERO
var Distance: float = 0.0
var ParentContainer : CONTAINERAPPS = null : set = _setParentContainer

signal CanMov()
signal QuitMov()

func _ready():
	self.gui_input.connect(_guiInput)
	
	if WhoShouldIDrag != null:
		Dragg = WhoShouldIDrag
	else:
		Dragg = self
	CanMov.connect(_canMov)
	QuitMov.connect(_quitMov)

func _process(delta):
	if clicking and !Movement:
		Distance = PositionClicked.distance_to(get_global_mouse_position())
		if Distance > DistanceToActivate:
			Movement = true
			CanMov.emit()
			AppsManager.GrabbingSomtheing = self
		else:
			print("NO ALCANZADO: ", str(Distance))

func _guiInput(event):
	if event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.is_pressed():
				if !clicking:
					PositionClicked = get_global_mouse_position()
					DragOffset = get_global_mouse_position() - Dragg.global_position
					clicking = true
				else:
					QuitMov.emit()


func _input(event):
	if AppsManager.GrabbingSomtheing != null and AppsManager.GrabbingSomtheing == self:
		print("Entro")
		var globalMouse : Vector2 = get_global_mouse_position()
		Dragg.global_position = globalMouse - DragOffset
		
	if clicking and QuitAfterReleas:
		if event is InputEventMouseButton:
			var mouse_event : InputEventMouseButton = event
			if mouse_event.button_index == MOUSE_BUTTON_LEFT:
				print("Segundo print")
				if mouse_event.is_released():
					QuitMov.emit()

func _setParentContainer(NewParCon : CONTAINERAPPS):
	if NewParCon != null:
		print("Entro el la casilla de : ",str(NewParCon))
		Dragg.z_index = AppsManager.BASEZINDEX
		var current_parent = Dragg.get_parent()
		if current_parent:
			current_parent.remove_child(Dragg)
		NewParCon.add_child(Dragg,true)
		Dragg.global_position = NewParCon.global_position
		ParentContainer = NewParCon
	elif ParentContainer != null:
		Dragg.global_position = ParentContainer.global_position


func _canMov():
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
func _quitMov():
	print("Lo solto")
	self.mouse_filter = Control.MOUSE_FILTER_STOP
	clicking = false
	Movement = false
	ParentContainer = AppsManager._getArrayContManager(self.TrowAt)
	AppsManager.GrabbingSomtheing = null
	Distance = 0.0
