extends Control

var current_meta:Dictionary = {}
var current_image:Texture2D
var folder_path = ''

# Main Nodes
@onready var nameDetail = $Top/MainPanel/Name
@onready var descDetail = $Top/MainPanel/Description
@onready var verDetail = $Top/MainPanel/Version

# Icon Nodes
@onready var icon = $Top/Image/TextureRect

# Contributors
@onready var list = $ContributorPanel/MarginContainer/Cont_Container
@onready var thewholedamnpanel = $ContributorPanel

var contributorButtonS = preload("res://source/buttons/ContButton.tscn")

func _on_button_button_down():
	if current_meta.homepage != "":
		OS.shell_open(current_meta.homepage)

func switch_meta(metadata, path):
	current_meta = metadata
	folder_path = path
	
	# Main Details
	if current_meta.has("title"):
		nameDetail.text = current_meta.title
	else:
		nameDetail.text = "No Title"
	if current_meta.has("desc"):
		descDetail.text = current_meta.desc
	else:
		descDetail.text = "No description"
	if current_meta.has("version"):
		verDetail.text = current_meta.version
	else:
		verDetail.text = "1.0.0"
	
	# Icon
	if FileAccess.file_exists(folder_path + "/_polymod_icon.png"):
		icon.texture = ImageTexture.create_from_image(Image.load_from_file(folder_path + "/_polymod_icon.png"))
	else:
		icon.texture = load("res://assets/images/icon_default.png")
	
	# Contributors
	if current_meta.contributors != []:
		for child in list.get_children():
			child.queue_free()
		thewholedamnpanel.visible = true
		for key in current_meta.contributors:
			var contributorButton = contributorButtonS.instantiate()
		
			if key.has("name"):
				contributorButton.contributor_name = key.name
			else:
				contributorButton.contributor_name = "No name"
			
			if key.has("role"):
				contributorButton.contributor_role = key.role
			else:
				contributorButton.contributor_role = "Developer"
			
			if key.has("url"):
				contributorButton.url = key.url
			else:
				contributorButton.url = ''
			
			list.add_child(contributorButton)
	else:
		thewholedamnpanel.visible = false
