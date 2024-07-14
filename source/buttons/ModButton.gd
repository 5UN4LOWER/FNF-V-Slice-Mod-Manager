extends Button

var modRes:ModResource
@onready var modDetails = $/root/Main/ModDetails

var checkbox:AnimatedSprite2D

func _ready():
	modRes.checkbox = checkbox

func _on_mouse_entered():
	var scaleTween = create_tween().tween_property(self, "scale", Vector2(1.1, 1.1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	modDetails.switch_meta(modRes.metadata, modRes.path)
	if not modDetails.visible: modDetails.visible = true

func _on_mouse_exited():
	var scaleTween = create_tween().tween_property(self, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func toggle():
	if modRes.enabled:
		modRes.disableMod()
	else:
		modRes.enableMod()
