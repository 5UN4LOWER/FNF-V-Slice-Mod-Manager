extends Control

# NOTE FOR JACKIE, NOTE FOR JACKIE, I REPEAT NOTE FOR JACKIE
# YOU NEED TO DO ANY COMPLICATED FOR WHEN YOU GET TO WORK ON REORDERING MODS, GODOT HAS A BUILT IN FUNCTION FOR IT
# move_child(get_child(index), target_index)

const save_path = "res://settings.txt"

# Data
var mods_folder = ''
var all_mods = []
var cmd = false

# Nodes
@onready var fileDialog = $FileDialog
@onready var capsule_scene = preload("res://scenes/Capsule.tscn")
@onready var capsule_container = $ScrollContainer/VBoxContainer

func _ready():
	# Load the selected mod folder, if the user hasn't selected one yet, automatically open the file dialog
	if not FileAccess.file_exists(save_path):
		fileDialog.visible = true
	else:
		mods_folder = FileAccess.open(save_path, FileAccess.READ).get_as_text()
		fileDialog.visible = false
		print("Current mod folder: " + mods_folder + str(all_mods))
		reload_mods()

func _process(_delta):
	pass

func reload_mods():
	# Clears all current capsules
	for capsule in capsule_container.get_children():
		capsule.queue_free()
	
	# Spawns capsules
	for mod_folder in DirAccess.open(mods_folder).get_directories():
		spawn_capsule(mod_folder.get_basename())

# When the user selects a mod directory
func onModFolderSelected(dir):
	FileAccess.open(save_path, FileAccess.WRITE).store_string(dir)
	mods_folder = dir
	print("Mod folder is now: " + dir)
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

func _on_cmd_button_toggled(toggled_on):
	cmd = toggled_on

# When the user presses the launch button
func onLaunchPressed():
	var drive = mods_folder.get_base_dir().replace("\\", "/").split("/")[0]
	var launch_files = [
		mods_folder.get_base_dir() + "/launch.bat",
		mods_folder.get_base_dir().get_base_dir()+"/MacOS/Funkin"
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
			var rawJSON = FileAccess.open(meta_path, FileAccess.READ).get_as_text()
			var json = JSON.parse_string(rawJSON)
			var capsule = capsule_scene.instantiate()
			capsule.name = folder_name
			capsule.text = json.title
			capsule.folder_path = mods_folder + "/" + folder_name
			capsule.enabled = bool(not meta_path.ends_with("_disabled.json"))
			capsule_container.add_child(capsule)
			all_mods.append(json.title)
			
			capsule.meta.title = json.title
			capsule.meta.desc = json.description
			if json.has("homepage"):
				capsule.meta.homepage = json.homepage
			if json.has("contributors"):
				capsule.meta.contributors = json.contributors
			if json.has("author"):
				capsule.meta.contributors.append({"name": json.author, "role": "Author", "url": ""})
			capsule.meta.version = json.mod_version
			
			if capsule.enabled:
				capsule.checkbox.play("checked")
			else:
				capsule.checkbox.play("unchecked")

