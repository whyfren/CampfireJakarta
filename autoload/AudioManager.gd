extends Node

# ── PRELOAD SEMUA AUDIO DI SINI ────────────────────────────
const MUSIC = {
	"main_music": preload("res://assets/Music/GameMusicCool.ogg")
}

const SFX = {
	"coin":       preload("res://assets/SFX/Coin.mp3"),
	"win":         preload("res://assets/SFX/win.mp3")
}
# ────────────────────────────────────────────────────────────

onready var music_player = $MusicPlayer
onready var sfx_player = $SFXPlayer

var music_volume = 1.0
var sfx_volume = 1.0

# ── MUSIC ───────────────────────────────────────────────────

func play_music(key: String):
	if not MUSIC.has(key):
		push_warning("AudioManager: musik '%s' tidak ditemukan!" % key)
		return
	var stream = MUSIC[key]
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.volume_db = linear2db(music_volume)
	music_player.play()

func stop_music():
	music_player.stop()

# ── SFX ─────────────────────────────────────────────────────

func play_sfx(key: String):
	if not SFX.has(key):
		push_warning("AudioManager: sfx '%s' tidak ditemukan!" % key)
		return
	sfx_player.stream = SFX[key]
	sfx_player.stream.loop = false  # ← tambah ini
	sfx_player.volume_db = linear2db(sfx_volume)
	sfx_player.play()

# ── VOLUME ───────────────────────────────────────────────────

func set_music_volume(value: float):
	music_volume = clamp(value, 0.0, 1.0)
	music_player.volume_db = linear2db(music_volume)

func set_sfx_volume(value: float):
	sfx_volume = clamp(value, 0.0, 1.0)
