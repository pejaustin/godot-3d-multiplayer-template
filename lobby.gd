extends Control

@onready var player_list = $VBoxContainer/PlayerList
@onready var start_button = $VBoxContainer/StartButton
@onready var lobby_code_label = $VBoxContainer/LobbyCode

func _ready():
	MultiplayerManager.player_joined.connect(_on_player_joined)
	MultiplayerManager.player_left.connect(_on_player_left)
	
	# Generate lobby code for easy joining
	if multiplayer.is_server():
		lobby_code_label.text = "Lobby Code: " + generate_lobby_code()

func generate_lobby_code() -> String:
	return str(randi_range(1000, 9999))

@rpc("any_peer", "call_local", "reliable")
func set_player_ready(peer_id: int, ready: bool):
	MultiplayerManager.players[peer_id]["ready"] = ready
	update_player_list()
	
	if multiplayer.is_server() and all_players_ready():
		start_button.disabled = false

func all_players_ready() -> bool:
	return MultiplayerManager.players.size() >= 2 and \
		   MultiplayerManager.players.values().all(func(p): return p.ready)

func _on_start_game_pressed():
	if multiplayer.is_server():
		MultiplayerManager.start_game.rpc()
