# Final-Project_PSD6: Hardware Accelerated Game of Life

**"The Game of Life Physics Engine"**

Proyek ini adalah implementasi _Hardware Accelerator_ untuk simulasi _Cellular Automata_ (Conway's Game of Life) menggunakan VHDL. Berbeda dengan simulasi software yang memproses data secara berurutan (sekuensial), sistem ini menggunakan arsitektur **Massively Parallel Processing**, di mana 64 sel logika menghitung nasibnya secara bersamaan dalam satu siklus clock.

Sistem ini juga dilengkapi dengan **CPU Mini (Microprogrammed Controller)** yang bertugas menggambar pola awal kehidupan ke dalam Grid sebelum simulasi dijalankan.

---

## Anggota Kelompok 6

| Nama                         | NPM        |
| ---------------------------- | ---------- |
| Djukallita Tafiana Djoewarsa | 2406416573 |
| Muhamad Rifqi Fadil Itsnain  | 2406355306 |
| Naziehan Labieb              | 2406487102 |
| Soraya Azzizah Pahlevi       | 2406487001 |

---

## Fitur Utama

1.  **Massively Parallel Grid:** 64 "Otak Sel" independen yang bekerja serentak (8x8 Grid).
2.  **Toroidal World:** Grid bersifat _wrap-around_ (ujung kiri nyambung ke kanan, atas nyambung ke bawah), sehingga pola tidak mati saat menabrak dinding.
3.  **Embedded CPU Controller:** Menggunakan FSM dan Microcode ROM untuk menyuntikkan pola awal (Glider) secara otomatis.
4.  **Hardware Visualization:** Output simulasi diekspor ke file teks (`output_game.txt`) untuk visualisasi pergerakan frame-by-frame.

---

## Penerapan Modul

Proyek ini mengintegrasikan materi dari Modul 2 hingga Modul 9 Praktikum PSD:

- **Modul 2 (Aritmetika):** Perhitungan jumlah tetangga (`Adder`) dan komparasi aturan hidup/mati.
- **Modul 3 (Sequential Logic):** Penggunaan Register pada setiap sel untuk menyimpan _state_ dan sinkronisasi update.
- **Modul 4 (Testbench & File I/O):** Testbench otomatis yang melakukan _dumping_ hasil grid ke file eksternal.
- **Modul 5 (Structural):** Desain hierarkis: `Top System` -> `Game Grid` -> `Cell Core`.
- **Modul 6 (Looping):** Penggunaan `FOR...GENERATE` untuk membuat dan menghubungkan 64 sel secara otomatis.
- **Modul 7 (Function):** Fungsi `get_next_state()` untuk memisahkan logika aturan permainan dari sirkuit utama.
- **Modul 8 (Finite State Machine):** Mengatur mode operasi sistem: `RESET` -> `WRITE` (Menggambar) -> `RUN` (Simulasi).
- **Modul 9 (Microprogramming):** Instruksi mikro di dalam ROM Controller untuk menggambar pola "Glider".

---

## Struktur File

- `top_system.vhd`: _Top-Level Entity_ yang menghubungkan CPU Controller dengan Grid 8x8.
- `game_controller.vhd`: CPU mini yang berisi ROM pola dan FSM pengendali.
- `game_grid_8x8.vhd`: Matriks 8x8 yang digenerate secara struktural dengan logika _wiring_ toroidal.
- `cell_core.vhd`: Unit terkecil (sel) yang berisi logika aturan Game of Life dan register memori.
- `tb_top_system.vhd`: Testbench utama untuk verifikasi dan generate output file.

---

## Hasil Output (Pola Glider)

Berikut adalah cuplikan hasil dari `output_game.txt` yang menunjukkan pola Glider bergerak miring ke kanan bawah:

```text
FRAME: 1
00000000
00000010
00001100
00000110
00000000
00000000
00000000
00000000
=================
FRAME: 2
00000000
00000100
00001000
00001110
00000000
00000000
00000000
00000000
=================
FRAME: 3
00000000
00000000
00001010
00001100
00000100
00000000
00000000
00000000
=================
...
```
