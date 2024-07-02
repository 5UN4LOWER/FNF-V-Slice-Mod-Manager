extends Button

var meta:Dictionary = {
	"title": "No Title",
	"desc": "No desc",
	"homepage": "",
	"contributors": [],
	"version": "0.1.0"
}
var image:Texture2D
var folder_path = ''
var enabled = true
@onready var checkbox = $AnimatedSprite2D

var enabledPath = folder_path + "/_polymod_meta.json"
var disabledPath = folder_path + "/_polymod_meta_disabled.json"

func _on_mouse_entered():
	var scaleTween = create_tween().tween_property(self, "scale", Vector2(1.1, 1.1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	$/root/Main/ModDetails.switch_meta(meta, folder_path)
	$/root/Main/ModDetails.visible = true

func _on_mouse_exited():
	var scaleTween = create_tween().tween_property(self, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func toggle():
	if enabled:
		disable()
	else:
		enable()

func disable():
	enabled = false
	checkbox.play('unchecked')
	print(name + ' is disabled')
	
	var dir = DirAccess.open(folder_path)
	dir.rename(folder_path + "/_polymod_meta.json", folder_path + "/_polymod_meta_disabled.json")

func enable():
	enabled = true
	checkbox.play("checked")
	print(name + ' is enabled')
	
	var dir = DirAccess.open(folder_path)
	dir.rename(folder_path + "/_polymod_meta_disabled.json", folder_path + "/_polymod_meta.json")

