extends Control

@onready var config = $ConfigButton
@onready var launch = $Launch
@onready var refresh = $RefreshButton
@onready var cmd = $CMDButton
@onready var muteSpr = $MuteButton/AnimatedSprite2D

var muted = false

func _ready():
	if OS.get_name() == "macOS":
		launch.disabled = true

func _on_mute_button_button_down():
	if not muted:
		# Mute
		AudioServer.set_bus_mute(0, true)
		muted = true
		muteSpr.play("mute")
	else:
		# Unmute
		AudioServer.set_bus_mute(0, false)
		muted = false
		muteSpr.play("unmute")

# Config Button
func _on_config_button_mouse_entered():
	var scaleTween = create_tween().tween_property(config, "scale", Vector2(0.65, 0.65), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var posTween = create_tween().tween_property(config, "position", Vector2(74, -5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_config_button_mouse_exited():
	var scaleTween = create_tween().tween_property(config, "scale", Vector2(0.57, 0.57), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var posTween = create_tween().tween_property(config, "position", Vector2(77, 4), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

# Launch Button
func _on_launch_mouse_entered():
	if OS.get_name() == "macOS":
		pass
	else:
		var scaleTween = create_tween().tween_property(launch, "scale", Vector2(1.08, 1.08), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		var posTween = create_tween().tween_property(launch, "position", Vector2(125, -18), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		var cmdPosTween = create_tween().tween_property(cmd, "position", Vector2(275, -50), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_launch_mouse_exited():
	if OS.get_name() == "macOS":
		pass
	else:
		var scaleTween = create_tween().tween_property(launch, "scale", Vector2(1, 1), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		var posTween = create_tween().tween_property(launch, "position", Vector2(141, -12), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
		
		var cmdPosTween = create_tween().tween_property(cmd, "position", Vector2(275, -46), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

# Refresh Button
func _on_refresh_button_mouse_entered():
	var scaleTween = create_tween().tween_property(refresh, "scale", Vector2(0.65, 0.65), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var posTween = create_tween().tween_property(refresh, "position", Vector2(10, -5), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)

func _on_refresh_button_mouse_exited():
	var scaleTween = create_tween().tween_property(refresh, "scale", Vector2(0.57, 0.57), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	var posTween = create_tween().tween_property(refresh, "position", Vector2(13, 4), 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
