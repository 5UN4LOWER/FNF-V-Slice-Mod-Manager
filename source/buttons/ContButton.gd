extends Button

var contributor_name = 'Contributor'
var contributor_role = 'Role'
var url = ''

func _process(_delta):
	text = contributor_name + " - " + contributor_role

func _on_button_down():
	if url != '':
		OS.shell_open(url)
