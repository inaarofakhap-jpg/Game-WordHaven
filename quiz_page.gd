extends Control

@onready var karakter_illit = $TextureProgressBar/karakterillit
@onready var label_question_title = $QuestionBar
@onready var label_question_text = $BoxQuestion/Question
@onready var btn_a = $VBoxContainer/Baris1/BtnOpsiA
@onready var btn_b = $VBoxContainer/Baris1/BtnOpsiB
@onready var btn_c = $VBoxContainer/Baris2/BtnOpsiC
@onready var btn_d = $VBoxContainer/Baris2/BtnOpsiD
@onready var btn_e = $VBoxContainer/BtnOpsiE
@onready var progress_bar = $TextureProgressBar

# Daftar soal
var daftar_soal = []
var index_soal_saat_ini = 0
var skor = 0
var jawaban_benar_total = 0
var jawaban_salah_total = 0

func _ready() -> void:
	karakter_illit.texture = load("res://assets/moka.png")
	daftar_soal = soal_kelas_x_level_1()
			
	if progress_bar:
		progress_bar.max_value = daftar_soal.size()
		
	# Background Quiz
	GlobalSound.play_bgm("res://assets/bgm_quiz.mp3")
	tampilkan_soal()

# Soal 
func soal_kelas_x_level_1() -> Array:
	return [
	{
		"soal": "Manager: \"Mr. Andi, why were you late to the meeting this morning?\"\nAndi: \"I apologize, Sir. My motorcycle had a flat tire on the way to the office.\"\nWhat does Andi express in the dialogue?",
		"opsi": [
			"Expressing an agreement",
			"Expressing an apology",
			"Expressing a gratitude",
			"Expressing a surprise",
			"Expressing a capability"
		],
		"jawaban": 1
	},
	{
		"soal": "Rina: \"If I finish my report early today, I ___ home early.\"\nComplete the conditional sentence correctly.",
		"opsi": [
			"go",
			"went",
			"will go",
			"would go",
			"had gone"
		],
		"jawaban": 2
	},
	{
		"soal": "Read the text:\n\"To all employees, please submit your monthly financial reports before Friday afternoon so that the finance team can audit them.\"\nWhy do employees need to submit the reports before Friday afternoon?",
		"opsi": [
			"So the manager can sign them",
			"So the finance team can audit them",
			"So the employees can take a holiday",
			"So the office can close early",
			"So the clients can check them"
		],
		"jawaban": 1
	},
	{
		"soal": "Sinta is the ___ student in her culinary vocational class.",
		"opsi": [
			"smart",
			"smarter",
			"smartest",
			"more smart",
			"most smart"
		],
		"jawaban": 2
	},
	{
		"soal": "Customer: \"Excuse me, could you show me where the digital cameras are?\"\nShop Assistant: \"Certainly, Sir. They are on the second floor, right next to the audio section.\"\nWhat is the shop assistant doing?",
		"opsi": [
			"Asking for information",
			"Giving directions and assistance",
			"Refusing a request",
			"Complaining about a product",
			"Offering a discount"
		],
		"jawaban": 1
	},
	{
		"soal": "The new CNC machine ___ by the technicians yesterday.",
		"opsi": [
			"repaired",
			"repairs",
			"is repairing",
			"was repaired",
			"has repaired"
		],
		"jawaban": 3
	},
	{
		"soal": "Job Vacancy Notice:\n\"We are looking for a dynamic secretary with fluent English skills and minimum 2 years of experience.\"\nWhat is the main requirement regarding work experience?",
		"opsi": [
			"No experience needed",
			"At least 2 years of experience",
			"Maximum 2 years of experience",
			"Exactly 1 year of experience",
			"More than 5 years of experience"
		],
		"jawaban": 1
	},
	{
		"soal": "Budi: \"I am planning to build a website for my small online shop, but I don't know how to code.\"\nDewi: \"If I were you, I would take an online web design course.\"\nThe bold/suggested phrase expresses...",
		"opsi": [
			"Giving a suggestion",
			"Asking for permission",
			"Storing an opinion",
			"Stating a certainty",
			"Expressing satisfaction"
		],
		"jawaban": 0
	},
	{
		"soal": "Budi: \"I am planning to build a website for my small online shop, but I don't know how to code.\"\nDewi: \"If I were you, **I would take an online web design course**.\"\nThe bold phrase expresses...",
		"opsi": [
			"Asking for permission",
			"Storing an opinion",
			"Stating a certainty",
			"Expressing satisfaction",
			"Giving a suggestion"
		],
		"jawaban": 4
	},
	{
		"soal": "Before entering the electronics workshop, all students ___ wear safety goggles and closed shoes.",
		"opsi": [
			"can",
			"may",
			"might",
			"could",
			"must"
		],
		"jawaban": 4
	},
]

# Menampilkan Soal
func tampilkan_soal() -> void:
	if index_soal_saat_ini < daftar_soal.size():
		var soal_data = daftar_soal[index_soal_saat_ini]
		
		if label_question_title:
			label_question_title.text = "QUESTION " + str(index_soal_saat_ini + 1)
		if label_question_text:
			label_question_text.text = soal_data["soal"]
			
		btn_a.text = "A. " + soal_data["opsi"][0]
		btn_b.text = "B. " + soal_data["opsi"][1]
		btn_c.text = "C. " + soal_data["opsi"][2]
		btn_d.text = "D. " + soal_data["opsi"][3]
		btn_e.text = "E. " + soal_data["opsi"][4]
		
		reset_warna_tombol()
		aktifkan_tombol(true)
		
		# PROGRESS BAR DAN POSISI KARAKTER :
		if progress_bar:
			progress_bar.value = index_soal_saat_ini
			
		# Karakter ILLIT berjalan
		if karakter_illit:
			var posisi_awal_x = 50.0  
			var posisi_akhir_x = 690.0
			var progres_persen = float(index_soal_saat_ini) / float(daftar_soal.size())
			karakter_illit.position.x = posisi_awal_x + ((posisi_akhir_x - posisi_awal_x) * progres_persen)
	else:
		GlobalGame.skor_akhir = skor
		GlobalGame.benar_total = jawaban_benar_total
		GlobalGame.salah_total = jawaban_salah_total
		GlobalGame.total_soal = daftar_soal.size()
		
		get_tree().change_scene_to_file("res://score_page.tscn")

# Mengecek jawaban (mencakup opsi A, B, C, D, E)
func cek_jawaban(pilihan_index: int, tombol_pilih: Button) -> void:
	aktifkan_tombol(false)
	var soal_data = daftar_soal[index_soal_saat_ini]
	
	# Array daftar tombol untuk pencocokan jawaban benar
	var daftar_tombol = [btn_a, btn_b, btn_c, btn_d, btn_e]
	
	if pilihan_index == soal_data["jawaban"]:
		tombol_pilih.modulate = Color.GREEN
		skor += 10
		jawaban_benar_total += 1
	else:
		tombol_pilih.modulate = Color.RED
		jawaban_salah_total += 1
		var tombol_benar = daftar_tombol[soal_data["jawaban"]]
		tombol_benar.modulate = Color.GREEN

	GlobalSound.play_sfx_quiz() # khusus tombol kuis
	
	await get_tree().create_timer(1.2).timeout
	index_soal_saat_ini += 1
	tampilkan_soal()
	
func reset_warna_tombol() -> void:
	btn_a.modulate = Color.WHITE
	btn_b.modulate = Color.WHITE
	btn_c.modulate = Color.WHITE
	btn_d.modulate = Color.WHITE
	btn_e.modulate = Color.WHITE

func aktifkan_tombol(status: bool) -> void:
	btn_a.disabled = !status
	btn_b.disabled = !status
	btn_c.disabled = !status
	btn_d.disabled = !status
	btn_e.disabled = !status

func _on_btn_opsi_a_pressed() -> void: cek_jawaban(0, btn_a)
func _on_btn_opsi_b_pressed() -> void: cek_jawaban(1, btn_b)
func _on_btn_opsi_c_pressed() -> void: cek_jawaban(2, btn_c)
func _on_btn_opsi_d_pressed() -> void: cek_jawaban(3, btn_d)
func _on_btn_opsi_e_pressed() -> void: cek_jawaban(4, btn_e)
# Go to Home

func _on_btn_home_pressed() -> void:
	GlobalSound.play_sfx_menu()
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_btn_back_pressed() -> void:
	GlobalSound.play_sfx_menu()
	get_tree().change_scene_to_file("res://latihan_soal.tscn")
