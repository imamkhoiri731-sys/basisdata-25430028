# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

**NIM:** 25430028

## 1. Latar belakang dan aktivitas organisasi

Kopma adalah koperasi di lingkungan kampus yang menjual alat tulis, makanan ringan, dan minuman. Pembelinya bisa anggota atau umum. Mahasiswa yang mendaftar sebagai anggota memperoleh nomor anggota berformat A-xxxx dan diskon 5% untuk setiap nota selama berstatus aktif.

Tiga kasir bekerja bergantian per sif untuk mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok dan memesan barang ke pemasok bila stok di bawah batas minimum. Barang yang datang dicocokkan dengan faktur pemasok lalu stok ditambah. Setiap awal bulan ketua menerima laporan omzet, barang terlaris, stok menipis, dan anggota paling aktif.

Keluhan yang melatarbelakangi dokumen ini: harga di nota lama tidak bisa dicek karena harga barang berubah, stok di buku catatan kadang minus, dan anggota sering lupa membawa kartu sehingga dicari lewat NIM.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Ada pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola status keanggotaan | Ketua koperasi | Anggota diaktifkan atau dinonaktifkan |

PB-06 dan PB-07 ditambahkan setelah pemeriksaan matriks CRUD (lihat bagian 7 dan Titik Analisis 3).

## 3. Dokumen sumber yang dianalisis

1. **Nota penjualan** (contoh PJ-2609-0142), lihat Gambar 2.5 pada buku praktikum.
   - Disimpan: nomor nota, tanggal-jam, kasir, anggota (opsional), barang, qty, harga satuan saat transaksi, bayar.
   - Turunan (dihitung): subtotal per baris, potongan diskon 5%, total. Nilai ini dapat dihitung ulang dari qty, harga, dan diskon.
2. **Formulir pendaftaran anggota**: NIM, nama, program studi, nomor HP. Nomor anggota diberikan koperasi.
3. **Faktur pemasok**: nomor faktur, tanggal, pemasok, barang, qty, harga beli.
4. **Kutipan wawancara** ketua, petugas gudang, dan kasir (sumber keluhan dan aturan bisnis).

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

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
| PB-06 Kelola data pemasok | | | | | C, R, U | |
| PB-07 Kelola status anggota | R, U | | | | | |

Catatan pemeriksaan: pada versi awal kolom Pemasok tidak pernah di-create oleh proses mana pun dan tidak ada proses yang mengubah status aktif anggota. Keduanya diperbaiki dengan menambahkan PB-06 dan PB-07.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| nama_anggota | Nama lengkap anggota | (isi contoh sendiri) | Wajib diisi | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| status_aktif | Status keanggotaan | aktif | Hanya anggota aktif mendapat diskon (AB-02) | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (rupiah), tidak berubah (AB-04) | Kasir |
| qty_detail_penjualan | Jumlah barang pada satu baris nota | 3 | Bilangan bulat > 0, tidak melebihi stok (AB-03) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |
| batas_minimum_stok | Batas stok untuk memicu pemesanan | 10 | Bilangan bulat >= 0 (AB-06) | Petugas gudang |
| harga_jual_barang | Harga jual terkini di daftar barang | 4000 | Bilangan bulat >= 0 | Petugas gudang |
| nama_pemasok | Nama pemasok | (isi contoh sendiri) | Wajib diisi | Petugas gudang |

Kamus ini baru cuplikan elemen penting setiap entitas. Boleh kamu lengkapi (misalnya kode barang, kategori, tanggal-jam nota, no_faktur_pembelian, harga_beli).

## 9. Kebutuhan non-fungsional data

- **Volume:** perkiraan +-150 nota per hari.
- **Retensi:** data transaksi disimpan minimal lima tahun.
- **Privasi:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua; kasir mencari anggota lewat NIM atau nomor anggota tanpa melihat nomor HP.

## 10. Isu kualitas data yang diantisipasi

1. **Akurasi historis:** harga di nota lama berubah bila hanya merujuk harga barang terkini. Pencegahan: AB-04.
2. **Konsistensi stok:** stok minus pada pencatatan manual. Pencegahan: AB-03 dan setiap perubahan stok punya rujukan nota atau faktur.
3. **Keunikan:** NIM atau nomor anggota ganda saat pendaftaran. Pencegahan: AB-05.
4. **Kelengkapan:** formulir pendaftaran tidak lengkap (misalnya nomor HP kosong atau salah format).
5. **Keamanan data pribadi:** nomor HP terlihat oleh petugas yang tidak berwenang.
