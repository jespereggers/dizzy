class_name Persistent
extends Node2D

export var properties_to_save :PoolStringArray = []

func serialize() -> Dictionary:
		assert(filename != "") #must be a packed scene
		var dict := {}
		dict["filename"] = filename
		for property in properties_to_save:
				var p = property.split(":")
				match p.size():
						1:
								assert(p[0] in self)
								dict[property] = get(p[0])
						2:
								assert(p[1] in get_node(p[0]))
								dict[property] = get_node(p[0]).get(p[1])
						_:
								assert(0)
		return dict

static func deserialize(dict:Dictionary,new_parent:Node2D) -> Persistent:
		var persistent : Persistent = load(dict.filename).instance()
		if new_parent:
				new_parent.add_child(persistent)
		for property in dict.keys():
				var p = property.split(":")
				match p.size():
						1:
								assert(p[0] in persistent)
								persistent.set(p[0],dict[property])
						2:
								assert(p[1] in persistent.get_node(p[0]))
								persistent.get_node(p[0]).set(p[1],dict[property])
						_:
								assert(0)
		persistent._on_loaded()
		if persistent.has_method("snap_to_position"):
				persistent.snap_to_position()
		return persistent
		
func _on_loaded(): #virtual
		pass  
