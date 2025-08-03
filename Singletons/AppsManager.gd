extends Node
class_name  APPSMANAGER 

const GMAIL = preload("res://Apps/Gmail.tscn")
const TERMINAL = preload("res://Apps/Terminal.tscn")
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
