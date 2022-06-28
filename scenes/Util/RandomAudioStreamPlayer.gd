extends Node

export(int) var numberToPlay := 2
export(bool) var enablePitchRandomization = true
export(float) var minPitchScale = .9
export(float) var maxPitchScale = 1.1

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()

func play():
	var validNodes := []
	for streamPlayer in get_children():
		if !(streamPlayer as AudioStreamPlayer).playing:
			validNodes.append(streamPlayer)
	
	for i in numberToPlay:
		if validNodes.size() == 0:
			break
		var idx:int = rng.randi_range(0, validNodes.size() -1)
		
		if enablePitchRandomization:
			(validNodes[idx] as AudioStreamPlayer).pitch_scale = rng.randf_range(minPitchScale, maxPitchScale)
		
		(validNodes[idx] as AudioStreamPlayer).play()
		validNodes.remove(idx)
