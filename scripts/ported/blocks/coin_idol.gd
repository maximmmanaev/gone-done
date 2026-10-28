# Ported from structur/CoinIdol.cs (Unity -> Godot skeleton, bodies not recovered from Il2Cpp dump)
class_name CoinIdol
extends Coin

var boulder_trap: Boulder
var triggered: bool

func pickup(chr: Character) -> void:  # C# Pickup
	pass

func return_coin_to_spawn():  # C# returnCoinToSpawn (coroutine)
	pass
