class_name ModResource extends Resource

@export var metadata:Dictionary = {
	"title": "",
	"desc": "",
	"homepage": "",
	"contributors": [],
	"version": "1.0.0"
}
@export var iconTexture:Texture2D
@export var path:String
@export var enabled:bool
@export var index:int = 0

var checkbox:AnimatedSprite2D

func disableMod():
	enabled = false
	checkbox.play('unchecked')
	print(metadata.title + ' is disabled')
	
	var dir = DirAccess.open(path)
	dir.rename(path + "/_polymod_meta.json", path + "/_polymod_meta_disabled.json")

func enableMod():
	enabled = true
	checkbox.play("checked")
	print(metadata.title + ' is enabled')
	
	var dir = DirAccess.open(path)
	dir.rename(path + "/_polymod_meta_disabled.json", path + "/_polymod_meta.json")

