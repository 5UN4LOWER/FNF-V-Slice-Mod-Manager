extends Control

# NOTE FOR JACKIE, NOTE FOR JACKIE, I REPEAT NOTE FOR JACKIE
# YOU NEED TO DO ANY COMPLICATED FOR WHEN YOU GET TO WORK ON REORDERING MODS, GODOT HAS A BUILT IN FUNCTION FOR IT
# move_child(get_child(index), target_index)

# Data
var mods_folder = ''
var all_mods = []
const save_path = "user://path.dat"

# Nodes
@onready var fileDialog = $FileDialog
@onready var modButtonScene = preload("res://source/buttons/ModButton.tscn")
@onready var modButtonContain = $ScrollContainer/VBoxContainer

func _ready():
	# Load the selected mod folder, if the user hasn't selected one yet, automatically open the file dialog
	if not FileAccess.file_exists(save_path):
		fileDialog.visible = true
	else:
		mods_folder = FileAccess.open(save_path, FileAccess.READ).get_as_text()
		fileDialog.visible = false
		print("Current mod folder: " + mods_folder)
		reload_mods()
	
	print(all_mods)

func _input(e):
	if e.is_action_pressed("back"):
		get_tree().quit

func reload_mods():
	for button in modButtonContain.get_children():
		button.queue_free()
	
	for mod_folder in DirAccess.open(mods_folder).get_directories():
		spawn_capsule(mod_folder.get_basename())

# When the user selects a mod directory
func onModFolderSelected(d):
	FileAccess.open(save_path, FileAccess.WRITE).store_string(d)
	mods_folder = d
	print("Mod folder is now: " + d)
	reload_mods()

func _on_file_dialog_canceled():
	if mods_folder != '':
		return
	else:
		await get_tree().create_timer(0.5).timeout
		fileDialog.show()

# When the user presses the config button
func configButton():
	fileDialog.visible = true

var cmd = false
func _on_cmd_button_toggled(toggled_on):
	cmd = toggled_on

# When the user presses the launch button
func onLaunchPressed():
	var drive = mods_folder.get_base_dir().replace("\\", "/").split("/")[0]
	var launch_files = [
		mods_folder.get_base_dir() + "/launch.bat",
		OS.get_executable_path().get_base_dir() + "/Funkin.app"
	]
	
	if OS.get_name() == "Windows":
		OS.create_process(launch_files[0], [drive, mods_folder.get_base_dir()], cmd)
	if OS.get_name() == "macOS":
		OS.create_process(launch_files[1], [], cmd)
	
	get_tree().quit()

func refreshButton():
	reload_mods()

func spawn_capsule(folder_name):
	var metas = [
		mods_folder + "/" + folder_name + "/_polymod_meta.json",
		mods_folder + "/" + folder_name + "/_polymod_meta_disabled.json"
	]
	for meta_path in metas:
		# Adds all mod folders
		if FileAccess.file_exists(meta_path):
			var json = JSON.parse_string(FileAccess.open(meta_path, FileAccess.READ).get_as_text())
			
			var modButton = modButtonScene.instantiate()
			modButton.name = folder_name
			modButton.text = json.title
			modButton.modRes.path = mods_folder + "/" + folder_name
			modButton.modRes.enabled = bool(not meta_path.ends_with("_disabled.json"))
			modButtonContain.add_child(modButton)
			all_mods.append(json.title)
			
			modButton.modRes.metadata.title = json.title
			modButton.modRes.metadata.desc = json.description
			if json.has("homepage"):
				modButton.modRes.metadata.homepage = json.homepage
			if json.has("contributors"):
				modButton.modRes.metadata.contributors = json.contributors
			if json.has("author"):
				modButton.modRes.metadata.contributors.append({"name": json.author, "role": "Author", "url": ""})
			modButton.modRes.metadata.version = json.mod_version
			
			if modButton.modRes.enabled:
				modButton.checkbox.play("checked")
			else:
				modButton.checkbox.play("unchecked")

func _process(_delta):
	$TextureRect.position = (-get_global_mouse_position() - Vector2(400, 2000)) / 50
