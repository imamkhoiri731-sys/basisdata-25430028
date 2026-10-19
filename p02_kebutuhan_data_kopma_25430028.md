# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

**Nama:** Imam Khoiri
**NIM:** 25430028
**Kelas:** A
**Tanggal:** 6 Oktober 2026
**Dosen/Asisten:** Dedi Irawan, S.Kom., M.T.I.
**Tema proyek:** Klinik
**Organisasi:** Klinik IK Sehat

## 1. Latar belakang dan aktivitas organisasi

Kopma adalah koperasi mahasiswa (fiktif) yang menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota atau pembeli umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat `A-xxxx`. Anggota aktif memperoleh diskon 5% untuk setiap nota.

Tiga kasir bekerja bergantian per sif untuk mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok. Bila stok suatu barang di bawah batas minimum, petugas gudang membuat pesanan pembelian ke pemasok, dan saat barang datang stok ditambah sesuai faktur pemasok. Setiap awal bulan ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Keluhan yang menjadi pemicu analisis (dari wawancara):

| Narasumber | Keluhan | Kebutuhan data yang tersirat |
|---|---|---|
| Ketua | Harga barang sering naik sehingga nota lama membingungkan | Harga harus disimpan per baris transaksi (AB-04) |
| Petugas gudang | Stok di buku catatan kadang minus | Stok tidak boleh negatif dan penambahan/pengurangan harus terlacak (AB-03) |
| Kasir | Anggota sering lupa kartu, dicari lewat NIM | Anggota harus dapat dicari lewat nomor anggota maupun NIM (AB-05) |

---

## 2. Aktor dan proses bisnis

Aktor: **Kasir** (3 orang, bergantian per sif), **Petugas gudang**, **Ketua koperasi**, serta pihak luar **Mahasiswa/pembeli** dan **Pemasok**.

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok *(ditambahkan, lihat Titik Analisis 3)* | Petugas gudang | Ada pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola status keanggotaan *(ditambahkan, lihat Titik Analisis 3)* | Ketua koperasi | Anggota berhenti atau kembali aktif |
| PB-08 | Mengelola data barang *(ditambahkan dari pemeriksaan matriks CRUD)* | Petugas gudang | Ada barang baru, perubahan harga jual, atau perubahan batas minimum |

Alur singkat per aktor:

- Kasir: PB-01 → PB-02 (mencetak nota).
- Petugas gudang: PB-08/PB-06 (pemeliharaan data) → PB-03 → PB-04.
- Ketua: PB-07 → PB-05.

---

## 3. Dokumen sumber yang dianalisis

Dokumen sumber utama adalah **nota penjualan** (contoh: `PJ-2609-0142`), ditambah formulir pendaftaran anggota dan faktur pemasok sebagai sumber entitas lain.

### 3.1 Pembedahan nota penjualan

Isi nota contoh:

```
KOPERASI MAHASISWA SEJAHTERA - Nota Penjualan
No. Nota : PJ-2609-0142
Tanggal  : 24-09-2026 10:15
Kasir    : Rina (K03)
Anggota  : A-0457 / Budi S.
-----------------------------------------------
Barang            Qty   Harga   Subtotal
Pulpen Gel 0.5      3   4.000     12.000
Buku Tulis 58       2   6.500     13.000
Air Mineral 600     1   4.000      4.000
-----------------------------------------------
Jumlah                            29.000
Diskon anggota 5%                  1.450
TOTAL                             27.550
Bayar tunai                       30.000
Kembali                            2.450
```

| Isian pada nota | Jenis | Keterangan |
|---|---|---|
| No. nota | Disimpan | Identitas transaksi, unik (AB-01) |
| Tanggal dan jam | Disimpan | Waktu transaksi |
| Kasir (kode dan nama) | Disimpan sebagai relasi | Cukup menyimpan kode petugas; nama diambil dari data petugas |
| Anggota (no. anggota dan nama) | Disimpan sebagai relasi (opsional) | Cukup menyimpan nomor anggota; kosong untuk pembeli umum (AB-02) |
| Nama barang | Relasi | Diambil dari data barang lewat kode barang |
| Qty | Disimpan | Per baris barang |
| Harga | Disimpan | **Harga saat transaksi**, bukan sekadar rujukan ke harga barang (AB-04) |
| Subtotal per baris | Turunan | qty × harga |
| Jumlah | Turunan | Penjumlahan subtotal |
| Diskon anggota 5% | Turunan | 5% × jumlah bila anggota aktif |
| TOTAL | Turunan | Jumlah − diskon |
| Bayar tunai | Disimpan | Uang yang diterima |
| Kembali | Turunan | Bayar − total |

Pemeriksaan hitung nota contoh: 3×4.000 + 2×6.500 + 1×4.000 = 29.000; diskon 5% = 1.450; total = 27.550; kembalian = 30.000 − 27.550 = 2.450.

### 3.2 Titik Analisis 1

**Pertanyaan:** Harga barang sudah tersimpan di data barang. Mengapa nota tetap perlu menyimpan harga saat transaksi?

**Jawaban:** Harga di data barang selalu mencerminkan harga terbaru. Jika nota hanya menunjuk ke data barang, maka ketika harga naik, semua nota lama ikut berubah nilainya: subtotal, total, dan omzet bulan lalu akan terhitung ulang dengan harga baru, dan angka yang pernah dicetak di nota kertas tidak lagi cocok dengan data. Inilah yang dikeluhkan ketua koperasi ("harga barang sering naik, jadi kami bingung saat melihat nota lama"). Dengan menyimpan harga satuan pada setiap baris detail penjualan (AB-04), nota lama tetap dapat dicek ulang dan laporan omzet historis tetap benar.

### 3.3 Titik Analisis 2

**Pertanyaan:** Sebutkan satu alasan tidak menyimpan subtotal/total dan satu alasan total mungkin tetap disimpan.

**Alasan tidak disimpan:** Nilai turunan dapat dihitung ulang dari qty, harga, dan diskon. Menyimpannya menciptakan duplikasi: jika qty atau harga pada suatu baris dikoreksi tetapi total tidak ikut diperbarui, data menjadi tidak konsisten.

**Alasan total mungkin tetap disimpan:** Total adalah angka yang benar-benar dibayar dan dicetak pada nota. Menyimpannya menjadi bukti yang tidak berubah meskipun aturan diskon atau pembulatan kelak berubah, dan mempercepat laporan omzet karena tidak perlu menjumlahkan semua baris detail setiap kali. Keputusan akhir dibahas di Modul 4.

---

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir/gudang/ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

Nilai turunan (tidak menjadi elemen disimpan pada tahap ini): subtotal baris, jumlah, diskon, total, kembalian.

---

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Poin loyalitas diperoleh anggota aktif: setiap kelipatan Rp10.000 total belanja bernilai 1 poin (pecahan dibulatkan ke bawah). *(Latihan E1)* |
| AB-08 | Poin ditukar dalam kelipatan 50 poin dengan potongan Rp5.000 per 50 poin; saldo poin tidak boleh negatif. *(Latihan E1)* |
| AB-09 | Setiap penambahan dan penukaran poin dicatat sebagai riwayat per transaksi, bukan hanya saldo akhir. *(Latihan E1)* |
| AB-10 | Pembelian berstatus diterima wajib memiliki petugas penerima; pembelian berstatus dipesan boleh belum memilikinya. |

Asumsi AB-07: poin dihitung dari total yang dibayar setelah diskon anggota dan setelah potongan penukaran poin. Pada nota contoh (total Rp27.550), anggota memperoleh 2 poin.

---

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Saldo poin setiap anggota pada saat tertentu *(Latihan E1)* | Anggota, mutasi poin |
| KI-06 | Total poin yang diterbitkan dan ditukar per bulan *(Latihan E1)* | Mutasi poin, penjualan |

---

## 7. Matriks CRUD

Matriks berikut sudah diperbarui dari matriks awal: ditambahkan kolom **Petugas** dan **Mutasi poin**, serta proses PB-06 sampai PB-10 supaya setiap entitas memiliki minimal satu proses yang membuatnya (C).

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian | Petugas | Mutasi poin |
|---|---|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | | | |
| PB-02 Catat penjualan | R, U (saldo poin) | R, U | C | C | | | R | C |
| PB-03 Pesan ke pemasok | | R | | | R | C | R | |
| PB-04 Terima barang | | U | | | R | U | R | |
| PB-05 Laporan bulanan | R | R | R | R | | R | | R |
| PB-06 Kelola data pemasok | | | | | C, U | | | |
| PB-07 Kelola status anggota | U | | | | | | | |
| PB-08 Kelola data barang | | C, U | | | | | | |
| PB-09 Tukar poin | R, U | | R | | | | R | C |
| PB-10 Kelola data petugas | | | | | | | C, U | |

Keterangan tambahan: PB-09 (menukar poin) dan PB-10 (mengelola data petugas, dikerjakan ketua) ditambahkan karena latihan E1 dan karena entitas Petugas tidak punya proses yang membuatnya.

### 7.1 Titik Analisis 3

**Pertanyaan:** Pada kolom Pemasok tidak ada proses yang memberi huruf C. Apa artinya, dan proses apa yang perlu ditambahkan? Siapa yang mengubah status aktif anggota?

**Jawaban:**
- Kolom Pemasok tanpa huruf C berarti ada proses yang terlewat: data pemasok dibaca oleh PB-03 dan PB-04, tetapi tidak ada proses yang membuatnya. Karena itu perlu ditambahkan **PB-06 Mengelola data pemasok** (C, U) yang dikerjakan petugas gudang.
- Status aktif anggota juga tidak diubah oleh proses mana pun (PB-01 hanya membuat anggota). Perlu ditambahkan **PB-07 Mengelola status keanggotaan** (U pada Anggota) yang dikerjakan **ketua koperasi**, sesuai kolom penanggung jawab no_anggota pada kamus data.
- Pemeriksaan yang sama pada matriks awal juga menemukan kolom Barang dan Petugas tanpa C, sehingga ditambahkan PB-08 dan PB-10.

---

## 8. Kamus data awal

| Elemen | Entitas | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|---|
| no_anggota | Anggota | Nomor anggota koperasi | A-0457 | Unik, format `A-` + 4 digit | Ketua |
| nim_anggota | Anggota | NIM anggota | 2301010123 | Unik, 10 digit (AB-05) | Ketua |
| nama_anggota | Anggota | Nama lengkap anggota | Budi S. | Wajib diisi | Ketua |
| prodi_anggota | Anggota | Program studi anggota | Ilmu Komputer | Wajib diisi | Ketua |
| no_hp_anggota | Anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas pada ketua | Ketua |
| status_aktif_anggota | Anggota | Status keanggotaan | Aktif | Aktif/Nonaktif; hanya anggota aktif dapat diskon (AB-02) | Ketua |
| saldo_poin_anggota | Anggota | Saldo poin loyalitas | 120 | Bilangan bulat ≥ 0 (AB-08) | Ketua |
| kode_barang | Barang | Kode unik barang | BRG-012 | Unik | Petugas gudang |
| nama_barang | Barang | Nama barang | Pulpen Gel 0.5 | Wajib diisi | Petugas gudang |
| kategori_barang | Barang | Kelompok barang | Alat tulis | Alat tulis/Makanan ringan/Minuman | Petugas gudang |
| harga_jual_barang | Barang | Harga jual terkini | 4000 | Bilangan bulat ≥ 0 (rupiah) | Petugas gudang |
| stok_barang | Barang | Jumlah barang tersedia | 35 | Bilangan bulat ≥ 0 (AB-03) | Petugas gudang |
| batas_min_stok_barang | Barang | Batas stok minimum untuk memesan | 10 | Bilangan bulat ≥ 0 (AB-06) | Petugas gudang |
| no_nota_penjualan | Penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota (AB-01) | Kasir |
| tgl_jam_penjualan | Penjualan | Waktu transaksi | 2026-09-24 10:15 | Wajib; tidak boleh di masa depan | Kasir |
| kode_petugas_penjualan | Penjualan | Kasir pencatat nota | K03 | Harus berperan kasir | Kasir |
| no_anggota_penjualan | Penjualan | Anggota pembeli (opsional) | A-0457 | Boleh kosong untuk pembeli umum (AB-02) | Kasir |
| bayar_penjualan | Penjualan | Uang yang dibayar | 30000 | Bilangan bulat ≥ total | Kasir |
| qty_detail_penjualan | Detail penjualan | Jumlah barang dalam satu baris | 3 | Bilangan bulat ≥ 1; ≤ stok (AB-03) | Kasir |
| harga_satuan_detail_penjualan | Detail penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat ≥ 0 (rupiah), tidak berubah (AB-04) | Kasir |
| kode_petugas | Petugas | Kode unik petugas | K03 | Unik | Ketua |
| nama_petugas | Petugas | Nama petugas | Rina | Wajib diisi | Ketua |
| peran_petugas | Petugas | Peran petugas | Kasir | Kasir/Gudang/Ketua | Ketua |
| kode_pemasok | Pemasok | Kode unik pemasok | PMS-03 | Unik | Petugas gudang |
| nama_pemasok | Pemasok | Nama pemasok | CV Maju Jaya | Wajib diisi | Petugas gudang |
| telepon_pemasok | Pemasok | Telepon pemasok | 0741xxxxxx | Angka, tidak boleh kosong | Petugas gudang |
| alamat_pemasok | Pemasok | Alamat pemasok | Jl. Merdeka 10 | Wajib diisi | Petugas gudang |
| no_faktur_pembelian | Pembelian | Nomor faktur pemasok | FK-0087 | Unik per pemasok | Petugas gudang |
| tgl_pembelian | Pembelian | Tanggal barang diterima | 2026-09-25 | Wajib | Petugas gudang |
| qty_detail_pembelian | Detail pembelian | Jumlah barang diterima | 50 | Bilangan bulat ≥ 1 | Petugas gudang |
| harga_beli_detail_pembelian | Detail pembelian | Harga beli saat faktur | 3000 | Bilangan bulat ≥ 0, disimpan per baris | Petugas gudang |
| poin_mutasi | Mutasi poin | Perubahan poin (+ diperoleh, − ditukar) | +2 / −50 | Bilangan bulat; ≠ 0 (AB-07, AB-08, AB-09) | Kasir |
| tgl_mutasi_poin | Mutasi poin | Waktu mutasi poin | 2026-09-24 10:15 | Wajib; dicatat otomatis | Kasir |
| spesialisasi_dokter | Bidang spesialisasi dokter | Penyakit Dalam | Wajib diisi | Admin klinik |
| no_resep | Nomor resep | RSP-2609-0031 | Unik per resep | Dokter |
| no_pembayaran | Nomor bukti pembayaran | BYR-2609-0018 | Unik per pembayaran | Kasir |
| status_bayar | Status pelunasan tagihan | Lunas | Hanya Lunas atau Belum lunas | Kasir |
| tanggal_pembelian | Tanggal faktur obat diterima | 2026-09-25 | Wajib, tidak boleh di masa depan | Apoteker |
| alamat_pemasok | Alamat pemasok obat | Jl. Merdeka No. 10 | Wajib diisi | Admin klinik |

---

## 9. Kebutuhan non-fungsional data

**Volume.** Sekitar ±150 nota per hari, atau ±54.750 nota per tahun. Dengan rata-rata 3 baris barang per nota, ±164.000 baris detail penjualan per tahun.

**Retensi.** Data transaksi (penjualan, detail penjualan, pembelian, mutasi poin) disimpan minimal lima tahun, sehingga basis data harus mampu menampung ±274.000 nota (±820.000 baris detail) tanpa penghapusan.

**Privasi dan akses.**

| Data | Jenis | Boleh melihat | Boleh mengubah |
|---|---|---|---|
| no_hp_anggota | Data pribadi | Hanya ketua | Ketua |
| nim_anggota, nama_anggota, prodi_anggota | Data pribadi umum | Ketua, kasir (untuk pencarian dan verifikasi) | Ketua |
| Data transaksi | Operasional | Kasir (miliknya), ketua | Tidak diubah setelah dicetak; koreksi lewat nota koreksi |
| Stok dan data pemasok | Operasional | Petugas gudang, ketua | Petugas gudang |

Pembatasan akses data pribadi sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi [17].

**Kebutuhan terukur lain.**
- Pencarian anggota lewat nomor anggota atau NIM menampilkan hasil dalam ≤ 2 detik (AB-05).
- Setiap perubahan status anggota dan harga barang dicatat dengan waktu dan pelakunya.

---

## 10. Isu kualitas data yang diantisipasi

| No | Isu | Dimensi mutu | Penyebab | Pencegahan |
|---|---|---|---|---|
| 1 | Stok bernilai minus | Akurasi | Penjualan melebihi stok atau stok belum diperbarui saat barang masuk | AB-03; penjualan ditolak bila qty > stok; PB-04 wajib dicatat |
| 2 | Harga nota lama berubah | Konsistensi | Harga hanya disimpan di data barang | Harga satuan disimpan per baris (AB-04) |
| 3 | NIM ganda atau salah ketik | Keunikan, validitas | Pendaftaran ulang atau salah input | NIM unik 10 digit (AB-05); cek sebelum mendaftar |
| 4 | Diskon diberikan ke anggota nonaktif | Validitas | Status tidak diperiksa saat transaksi | AB-02; periksa status aktif sebelum diskon |
| 5 | Nomor HP bocor atau salah format | Keamanan, validitas | Akses terlalu luas atau input bebas | Akses hanya ketua; format angka tervalidasi |
| 6 | Total di nota tidak sama dengan jumlah baris | Konsistensi | Total disimpan dan tidak diperbarui saat koreksi | Total dihitung dari baris; pertimbangkan di Modul 4 |
| 7 | Saldo poin tidak sesuai riwayat | Akurasi | Saldo diubah tanpa mutasi | AB-09; saldo selalu dapat direkonsiliasi dari mutasi |

---

## Lampiran A. Latihan E1: Poin loyalitas

**Ketentuan:** setiap kelipatan Rp10.000 belanja anggota bernilai 1 poin, dan 50 poin dapat ditukar dengan potongan Rp5.000.

**Elemen data baru:**
- `saldo_poin_anggota` pada Anggota (lihat kamus data);
- entitas baru **Mutasi poin** dengan `poin_mutasi`, `tgl_mutasi_poin`, anggota, dan nota terkait;
- `potongan_poin_penjualan` pada Penjualan (nilai rupiah potongan dari penukaran poin; 0 bila tidak menukar).

**Aturan bisnis baru:** AB-07, AB-08, AB-09 (pada bagian 5).

**Kebutuhan informasi baru:** KI-05 dan KI-06 (pada bagian 6).

**Pembaruan matriks CRUD:** kolom Mutasi poin; PB-02 ditambah C pada Mutasi poin dan U pada saldo Anggota; proses baru PB-09 Tukar poin; PB-05 membaca Mutasi poin (lihat bagian 7).

**Contoh perhitungan.** Nota Rp27.550 menghasilkan ⌊27.550 / 10.000⌋ = 2 poin. Anggota dengan 120 poin boleh menukar 100 poin (kelipatan 50) untuk potongan Rp10.000; sisa saldo 20 poin dan satu baris mutasi −100 tercatat.

## Lampiran B. Latihan E2: Memperbaiki pernyataan kebutuhan kabur

| Pernyataan kabur | Versi spesifik, terukur, dapat diuji |
|---|---|
| (a) "Data anggota harus aman" | Nomor HP anggota hanya dapat dilihat oleh akun ketua; akun kasir yang meminta data tersebut ditolak dan hanya menerima no_anggota, nama, dan status. Setiap perubahan data anggota dicatat dengan waktu dan pelakunya. Uji: login sebagai kasir lalu coba menampilkan nomor HP; hasil harus ditolak atau disembunyikan. |
| (b) "Sistem harus cepat mencari barang" | Pencarian barang berdasarkan kode atau sebagian nama menampilkan hasil dalam ≤ 2 detik pada data hingga 1.000 barang. Uji: jalankan 10 pencarian acak dan ukur waktu tiap pencarian; semuanya harus ≤ 2 detik. |
| (c) "Laporan stok harus akurat" | Stok pada laporan sama dengan stok awal + total penerimaan − total penjualan untuk setiap barang, dan tidak ada barang bernilai negatif. Uji: pada akhir bulan, bandingkan 10 barang sampel dengan hitungan fisik; selisih harus 0. |

Catatan: angka 1.000 barang dan 10 sampel adalah asumsi saya sendiri; sesuaikan bila dosen atau studi kasus Anda menetapkan lain.
