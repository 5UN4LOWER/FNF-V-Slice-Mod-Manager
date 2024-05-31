extends Control

var current_meta:Dictionary = {}
var current_image:Texture2D
var folder_path = ''

var cont_button_scene = preload("res://contributor_button.tscn")

func _on_button_button_down():
	if current_meta.homepage != "":
		OS.shell_open(current_meta.homepage)

func switch_meta(metadata, path):
	current_meta = metadata
	folder_path = path
	# Main Details
	if current_meta.has("title"):
		$MainDetails/Name.text = current_meta.title
	else:
		$MainDetails/Name.text = "No Title"
	if current_meta.has("desc"):
		$MainDetails/Description.text = current_meta.desc
	else:
		$MainDetails/Description.text = "No description"
	if current_meta.has("version"):
		$MainDetails/Version.text = current_meta.version
	else:
		$MainDetails/Version.text = "1.0.0"
	
	# Icon
	if FileAccess.file_exists(folder_path + "/_polymod_icon.png"):
		$Image/TextureRect.texture = ImageTexture.create_from_image(Image.load_from_file(folder_path + "/_polymod_icon.png"))
	else:
		$Image/TextureRect.texture = load("res://images/icon_default.png")
	
	# Contributors
	if current_meta.contributors != []:
		for child in $Contributors/Cont_Container.get_children():
			child.queue_free()
		$Contributors.visible = true
		for key in current_meta.contributors:
			var contributorS = cont_button_scene.instantiate()
		
			if key.has("name"):
				contributorS.contributor_name = key.name
			else:
				contributorS.contributor_name = "No name"
			
			if key.has("role"):
				contributorS.contributor_role = key.role
			else:
				contributorS.contributor_role = "Developer"
			
			if key.has("role"):
				contributorS.url = key.url
			else:
				contributorS.url = ''
			
			$Contributors/Cont_Container.add_child(contributorS)
	else:
		$Contributors.visible = false
