extends NinePatchRect

@onready var popup = $file_menu.get_popup()

@onready var screen = get_parent()

var file_created:bool

func _ready() -> void:

	Global.emit_signal("next_step",self)
	Global.connect("create_image_file", _on_file_created)
	
	popup.id_pressed.connect(func(id: int):
		menu_popup(id))

func menu_popup(id):
	if id == 0:
		if !Global.file_created: 
			screen.add_child(preload("res://pc/level1/select_source.tscn").instantiate())
		
func _on_file_created():
	var tree = $evidence_tree
	Global.file_created = true
	var sd_image_001 = tree.create_item()
	var partition_1 = tree.create_item(sd_image_001)
	
	var fat16 = tree.create_item(partition_1)
	var root = tree.create_item(fat16)
	var svi = tree.create_item(root)
	var unallocated = tree.create_item(fat16,1)
	
	var unpartitioned = tree.create_item(partition_1,1)
	var unallocated2 = tree.create_item(unpartitioned)
	
	sd_image_001.set_collapsed(true)
	partition_1.set_collapsed(true)
	fat16.set_collapsed(true)
	root.set_collapsed(true)
	unpartitioned.set_collapsed(true)
	
	sd_image_001.set_text(0,"SD-image-file.001")
	partition_1.set_text(0, "Partition 1 [967MB]")
	
	fat16.set_text(0,"1GB [FAT16]")
	root.set_text(0, "[root]")
	svi.set_text(0, "System Volume Information")
	unallocated.set_text(0,"[unallocated space]")
	
	unpartitioned.set_text(0,"Unpartitioned Space [basic disk]")
	unallocated2.set_text(0, "[unallocated space] ")
	
	while !Global.hash_array:
		await get_tree().process_frame
	$md5_label.text = "MD5: " + Global.hash_array[0]
	$sha1_label.text = "SHA1: " + Global.hash_array[1]

func _on_evidence_tree_item_selected() -> void:
	var selected:String = $evidence_tree.get_selected().get_text($evidence_tree.get_selected_column())
	var tree = $file_list
	tree.clear()
	
	if selected == "1GB [FAT16]":
		var fat16 = tree.create_item()
		var root = tree.create_item()
		var unallocated = tree.create_item()
		var fat1 = tree.create_item()
		var fat2 = tree.create_item()
		var fss = tree.create_item()
		var reserved = tree.create_item()
		var vbr = tree.create_item()
		
		root.set_text(0,"[root]")
		unallocated.set_text(0,"[unallocated space]")
		fat1.set_text(0,"FAT1")
		fat2.set_text(0,"FAT2")
		fss.set_text(0,"file system slack")
		reserved.set_text(0,"reserved sectors")
		vbr.set_text(0,"VBR")
		
	elif selected == "[root]":
		var root = tree.create_item()
		var svi = tree.create_item()

		var img1 = tree.create_item()
		var img1_slack = tree.create_item()
		var img2 = tree.create_item()
		#var img2_slack = tree.create_item()
		var img3 = tree.create_item()
		var img3_slack = tree.create_item()
		var img4 = tree.create_item()
		var img4_slack = tree.create_item()

		svi.set_text(0,"System Volume Information")
		img1.set_text(0,"!mage.1jpg")
		img1_slack.set_text(0,"!mage1.jpg.FileSlack")
		img2.set_text(0,"!mage.2jpg")
		#img2_slack.set_text(0,"!mage2.jpg.FileSlack")
		img3.set_text(0,"!mage.3jpg")
		img3_slack.set_text(0,"!mage3.jpg.FileSlack")
		img4.set_text(0,"!mage.4jpg")
		img4_slack.set_text(0,"!mage4.jpg.FileSlack")
		
	elif selected == "System Volume Information":
		var svi = tree.create_item()
		var indexer = tree.create_item()
		var indexer_slack = tree.create_item()
		var wps = tree.create_item()
		var wps_slack = tree.create_item()

		wps.set_text(0,"WPSettings.dat")
		wps_slack.set_text(0,"WPSettings.dat.FileSlack")
		
		indexer.set_text(0,"IndexerVolumeGuid")
		indexer_slack.set_text(0,"IndexerVolumeGuid.FileSlack")
		
	elif selected == "[unallocated space]":
		var unalloacted_tree = tree.create_item()
		var f_0 = tree.create_item()
		var f_1 = tree.create_item()
		var f_2 = tree.create_item()
		var f_3 = tree.create_item()
		var f_4 = tree.create_item()
		var f_5 = tree.create_item()
		var f_6 = tree.create_item()
		var f_7 = tree.create_item()
		var f_8 = tree.create_item()
		var f_9 = tree.create_item()
		var f_10 = tree.create_item()
		
		f_0.set_text(0,"00004")
		f_1.set_text(0,"00013")
		f_2.set_text(0,"06413")
		f_3.set_text(0,"12813")
		f_4.set_text(0,"19213")
		f_5.set_text(0,"25613")
		f_6.set_text(0,"32013")
		f_7.set_text(0,"38413")
		f_8.set_text(0,"44813")
		f_9.set_text(0,"51213")
		f_10.set_text(0,"57613")

	elif selected == "Unpartitioned Space [basic disk]":
		var unpartitioned = tree.create_item()
		var unallocated = tree.create_item()
		var mbr = tree.create_item()
		
		unallocated.set_text(0,"[unallocated space]")
		mbr.set_text(0,"MBR")
		
	elif selected == "[unallocated space] ":
		var unallocated = tree.create_item()
		var f_0 = tree.create_item()
		var f_1 = tree.create_item()
		
		f_0.set_text(0,"0000001")
		f_1.set_text(0,"1983936")
		
	else:
		tree.clear()
	
