extends VBoxContainer
class_name  APPLICATION

@onready var logopartcol = $HEAD/HBoxContainer/LOGOPARTCOL
@onready var logopart = $HEAD/HBoxContainer/LOGOPARTCOL/LOGOPART



@onready var gui = $HEAD/HBoxContainer/GUI
@onready var extras = $HEAD/HBoxContainer/EXTRAS

@onready var mincol = $HEAD/HBoxContainer/GUI/MINCOL
@onready var maxcol = $HEAD/HBoxContainer/GUI/MAXCOL
@onready var closecol = $HEAD/HBoxContainer/GUI/CLOSECOL

@export var LOGO : Texture2D : set = _setLogo



func _ready():
	logopart.texture = LOGO

#Se queda
func _setLogo(NEWLOGO : Texture2D):
	LOGO = NEWLOGO
	if NEWLOGO != null and logopart != null:
		logopart.texture = NEWLOGO
