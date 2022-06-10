extends Position2D

enum Direction { RIGHT, LEFT }

export(PackedScene) var enemyScene
export(Direction) var startDirection

var currentEnemyNode = null
var spwanOnNextTick = false

func _ready() -> void:
	$SpwanTimer.connect("timeout", self, "on_spawn_timer_rimeout")
	call_deferred("spwan_enemy")
	
func spwan_enemy():
	currentEnemyNode = enemyScene.instance()
	currentEnemyNode.startDirection = Vector2.RIGHT if startDirection == Direction.RIGHT else Vector2.LEFT
	get_parent().add_child(currentEnemyNode)
	currentEnemyNode.global_position = global_position

func check_enemy_spwan():
	if !is_instance_valid(currentEnemyNode):
		if spwanOnNextTick:
			spwan_enemy()
			spwanOnNextTick = false
		else:
			spwanOnNextTick = true

func on_spawn_timer_rimeout():
	check_enemy_spwan()
