extends Node
class_name  APPSMANAGER 

enum KINDSAPPS{
	WINDOW,
	FOOTERAPP,
	GUIAPP
}
var ContainerMangerArray : Array[CONTAINERAPPS] = []
var GrabbingSomtheing : DRAGCOMPONENT = null

const GMAIL = preload("res://Apps/Gmail.tscn")
const TERMINAL = preload("res://Apps/Terminal.tscn")
const BASEZINDEX : int = 1

@onready var scene_1 = $"."
@onready var monitor = %Monitor as MONITOR

@export var AllApps : Array[PackedScene] = [TERMINAL,null ,TERMINAL,GMAIL]
var appsNeeded : Array[PackedScene] = AllApps
@export var ExistentApps: Array[TextureRect]
@export var WhoIsAbove : ColorRect = null
var OnMouseOn : TextureRect = null

var WhoIsGrabbing : TextureRect = null : set =_whoIsGrabbing
var OnMouseEntered : TextureRect = null
var OnMouseExited : TextureRect = null : set = _onMouseExited
var WhoPressed : TextureRect = null : set = _whowasPressed

signal DroppApp(WhoWasDropped : TextureRect)


func _allWasCreated(wasCreated : bool, who : ColorRect):
	if wasCreated:
		who.mouse_entered.connect(who._mouseEntered)
	else:
		who.mouse_entered.disconnect(who._mouseEntered)
		WhoIsAbove = null

func _onMouseExited(TEXTUre : TextureRect):
	OnMouseExited = TEXTUre
	if TEXTUre != null :
		if TEXTUre == OnMouseEntered:
			OnMouseEntered = null

func _whoIsGrabbing(WHo : TextureRect):
	
	print("SEBERIA IMPRIMIRSE DROPPAP")
	if WHo == null and WhoIsGrabbing != null:
		DroppApp.emit(WhoIsGrabbing)
	WhoIsGrabbing = WHo

func _whowasPressed(WHO : TextureRect):
	#if WHO != null:
	#	WHO.modulate = WHO.ColorChose
	#if WhoPressed != null:
	#	WhoPressed.modulate = Color(1, 1, 1, 1)
	WhoPressed = WHO


func _arrayContManager(WHO : CONTAINERAPPS, isAdding : bool):
	var bodyinteract2 = null
	if isAdding:
		print("ENTRO ARRAY: ",str(WHO))
		if ContainerMangerArray.size() > 0:
			for target in ContainerMangerArray:
				if target == WHO:
					return
			ContainerMangerArray.append(WHO)
		else:
			ContainerMangerArray.append(WHO)
	else:
		print("Salio ARRAY: ",str(WHO))
		if ContainerMangerArray.size() > 0:
			for target in ContainerMangerArray:
				if target == WHO:
					ContainerMangerArray.erase(WHO)

func _getArrayContManager(Kind : KINDSAPPS) -> CONTAINERAPPS:
	if ContainerMangerArray.size() != 0:
		for Target in ContainerMangerArray:
			if Target.Contain == Kind:
				return Target
	return null
