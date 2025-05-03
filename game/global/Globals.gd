extends Node

#var HEALTH = 10

const LAYER_PLAYER = 1
const LAYER_ENVIRONMENT = 2
const LAYER_ENEMY = 3

var game_music_volume = -20
var is_game_paused

enum StrangerState {
	DEFAULT, SMOKING, ASKED
}
