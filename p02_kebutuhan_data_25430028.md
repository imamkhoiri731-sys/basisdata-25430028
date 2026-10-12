# Dokumen Kebutuhan Data - Klinik Pratama Harapan Sehat (fiktif)

**NIM:** 25430028  **Tema:** Klinik (kode tema: klinik)

## 1. Latar belakang dan aktivitas organisasi

Klinik Pratama Harapan Sehat adalah klinik rawat jalan fiktif yang melayani pemeriksaan umum, gigi, dan kesehatan ibu dan anak. Pasien mendaftar di loket, diperiksa dokter di poli yang dipilih, menerima tindakan dan resep bila perlu, lalu membayar di kasir. Obat diserahkan oleh apoteker setelah resep dibuat dokter.

Masalah yang mendasari kebutuhan data: berkas pasien yang pernah berkunjung sering terduplikasi karena pasien lupa nomor rekam medis, tarif tindakan dan harga obat berubah sehingga catatan lama tidak bisa dicek, stok obat kadang kosong saat resep sudah dibuat, dan data kesehatan pasien harus dijaga agar tidak dibaca petugas yang tidak berkepentingan. Kepala klinik juga membutuhkan laporan bulanan tentang kunjungan, penyakit terbanyak, stok obat menipis, dan pendapatan.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan pasien baru | Petugas pendaftaran | Pasien baru datang |
| PB-02 | Mencatat kunjungan | Petugas pendaftaran | Pasien ingin berobat |
| PB-03 | Memeriksa pasien dan mencatat tindakan | Dokter | Pasien dipanggil ke poli |
| PB-04 | Menulis resep | Dokter | Pasien membutuhkan obat |
| PB-05 | Menyerahkan obat | Apoteker | Resep diterima apotek |
| PB-06 | Memproses pembayaran | Kasir | Pasien selesai diperiksa |
| PB-07 | Mengelola data master (dokter, poli, tindakan, obat) | Admin klinik | Ada data baru atau perubahan tarif, harga, jadwal |
| PB-08 | Memperbarui data pasien | Petugas pendaftaran | Data pasien berubah atau salah ketik |
| PB-09 | Menyusun laporan bulanan | Kepala klinik | Awal bulan |

## 3. Dokumen sumber yang dianalisis

Dokumen sumber rancangan sendiri: **Lembar Kunjungan Pasien**.

```
KLINIK PRATAMA HARAPAN SEHAT - LEMBAR KUNJUNGAN
No. Kunjungan : KJ-2610-0007        Tanggal-jam : 12/10/2026 09:15
No. RM        : RM-000123           Nama        : Budi Santoso
Poli          : Umum                Dokter      : dr. Ayu Lestari
Keluhan       : Demam 3 hari
Diagnosis     : Infeksi saluran pernapasan atas

TINDAKAN                    Tarif
1. Pemeriksaan umum         Rp 40.000
2. Cek suhu dan tensi       Rp  5.000

RESEP                       Qty   Harga     Aturan pakai
1. Paracetamol 500 mg       10    Rp 1.000  3 x 1 sesudah makan
2. Amoxicillin 500 mg       15    Rp 2.000  3 x 1 habiskan

Total tindakan : Rp 45.000
Total obat     : Rp 40.000
Total tagihan  : Rp 85.000     Status bayar: Lunas
```

Pembedahan isian (data disimpan atau turunan):

| Isian | Status | Entitas | Alasan |
|---|---|---|---|
| No. Kunjungan, tanggal-jam | Disimpan | Kunjungan | Identitas dan waktu kejadian |
| No. RM, nama | Disimpan | Pasien | Identitas pasien; nama dibaca lewat no. RM |
| Poli, dokter | Disimpan (rujukan) | Kunjungan | Menunjuk Poli dan Dokter |
| Keluhan, diagnosis | Disimpan | Kunjungan | Hasil pemeriksaan, data kesehatan |
| Nama tindakan | Rujukan | Tindakan | Diambil dari daftar tindakan |
| Tarif tindakan di lembar | Disimpan per baris | Detail tindakan | Harus tetap meski tarif master naik (AB-04) |
| Nama obat | Rujukan | Obat | Diambil dari daftar obat |
| Qty, harga obat, aturan pakai | Disimpan per baris | Resep dan detailnya | Harga saat transaksi (AB-04) |
| Total tindakan, total obat, total tagihan | Turunan | - | Dapat dihitung dari baris tindakan dan baris resep |
| Status bayar | Disimpan | Pembayaran | Dipakai untuk laporan tagihan belum lunas |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Pasien | no. RM, NIK, nama, tanggal lahir, jenis kelamin, no. HP, alamat | Formulir pendaftaran |
| Dokter | kode dokter, nama, no. STR, spesialisasi | Data admin klinik |
| Poli | kode poli, nama poli | Data admin klinik |
| Kunjungan | no. kunjungan, tanggal-jam, pasien, dokter, poli, keluhan, diagnosis | Lembar kunjungan |
| Tindakan | kode tindakan, nama tindakan, tarif | Daftar tarif |
| Detail tindakan | no. kunjungan, tindakan, tarif saat tindakan | Lembar kunjungan |
| Obat | kode obat, nama, harga jual, stok, batas minimum stok, tanggal kedaluwarsa | Daftar obat, faktur |
| Resep dan detailnya | no. resep, kunjungan, obat, qty, harga saat resep, aturan pakai | Lembar kunjungan |
| Pembayaran | no. pembayaran, kunjungan, tanggal bayar, jumlah bayar, metode, denda | Kuitansi |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | No. RM unik dan NIK pasien unik (16 digit); satu orang hanya boleh memiliki satu berkas pasien. |
| AB-02 | Setiap kunjungan terhubung ke tepat satu pasien, satu dokter, dan satu poli, dengan tanggal-jam tercatat otomatis. |
| AB-03 | Satu kunjungan memuat paling banyak 4 baris tindakan dan satu resep memuat paling banyak 4 baris obat (P + 2 = 4). |
| AB-04 | Tarif tindakan dan harga obat disimpan per baris pada saat transaksi dan tidak berubah meski data master kemudian berubah. |
| AB-05 | Stok obat tidak boleh negatif; obat tidak dapat diserahkan bila qty melebihi stok. |
| AB-06 | Obat yang melewati tanggal kedaluwarsa tidak boleh diserahkan. |
| AB-07 | Setiap kunjungan memiliki paling banyak satu pembayaran lunas dan jumlah bayar harus sama dengan total tagihan. |
| AB-08 | Tagihan yang belum lunas setelah 7 hari dikenai denda Rp2.000 per hari keterlambatan (P = 2 ribu rupiah). |
| AB-09 | Diagnosis dan keluhan hanya dapat dibaca dokter yang menangani dan kepala klinik; petugas pendaftaran dan kasir tidak dapat membacanya. |
| AB-10 | Data kunjungan dan pembayaran tidak dihapus; kesalahan input dikoreksi dengan perubahan data yang tercatat. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Jumlah kunjungan per poli per hari dan per bulan | Kunjungan, poli |
| KI-02 | Sepuluh diagnosis terbanyak per bulan | Kunjungan |
| KI-03 | Obat dengan stok di bawah batas minimum dan obat yang hampir kedaluwarsa | Obat |
| KI-04 | Pendapatan per bulan dari tindakan dan dari obat | Detail tindakan, resep, pembayaran |
| KI-05 | Daftar tagihan belum lunas beserta denda berjalan | Kunjungan, pembayaran |
| KI-06 | Riwayat kunjungan seorang pasien berdasarkan no. RM atau NIK | Pasien, kunjungan |

## 7. Matriks CRUD

| Proses | Pasien | Dokter | Poli | Kunjungan | Tindakan | Detail tindakan | Obat | Resep | Pembayaran |
|---|---|---|---|---|---|---|---|---|---|
| PB-01 Daftar pasien baru | C | | | | | | | | |
| PB-02 Catat kunjungan | R | R | R | C | | | | | |
| PB-03 Periksa dan catat tindakan | | | | R, U | R | C | | | |
| PB-04 Tulis resep | | | | R | | | R | C | |
| PB-05 Serahkan obat | | | | | | | R, U | R, U | |
| PB-06 Proses pembayaran | | | | R | | R | | R | C, U |
| PB-07 Kelola data master | | C, R, U | C, R, U | | C, R, U | | C, R, U | | |
| PB-08 Perbarui data pasien | R, U | | | | | | | | |
| PB-09 Laporan bulanan | R | | R | R | | R | R | R | R |

Catatan: tidak ada huruf D karena data medis dan transaksi disimpan sesuai masa retensi (AB-10). Setiap entitas memiliki minimal satu proses yang melakukan C.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_rm | Nomor rekam medis pasien | RM-000123 | Unik, format RM-6 digit | Petugas pendaftaran |
| nik_pasien | NIK pasien | 1871xxxxxxxxxxxx | Unik, 16 digit, data pribadi | Petugas pendaftaran |
| nama_pasien | Nama lengkap pasien | Budi Santoso | Wajib diisi | Petugas pendaftaran |
| tanggal_lahir_pasien | Tanggal lahir | 1990-05-14 | Tidak boleh di masa depan | Petugas pendaftaran |
| jenis_kelamin_pasien | Jenis kelamin | L | Nilai L atau P | Petugas pendaftaran |
| no_hp_pasien | Nomor HP pasien | 0812xxxx | Data pribadi, akses terbatas | Petugas pendaftaran |
| alamat_pasien | Alamat tempat tinggal | Jl. Contoh No. 5 | Data pribadi | Petugas pendaftaran |
| kode_dokter | Kode dokter | DR-01 | Unik | Admin klinik |
| nama_dokter | Nama dokter | dr. Ayu Lestari | Wajib diisi | Admin klinik |
| no_str_dokter | Nomor STR dokter | 3174xxxx | Unik, wajib bagi dokter | Admin klinik |
| kode_poli | Kode poli | PL-UM | Unik | Admin klinik |
| nama_poli | Nama poli | Umum | Wajib diisi | Admin klinik |
| no_kunjungan | Nomor kunjungan | KJ-2610-0007 | Unik per kunjungan | Petugas pendaftaran |
| tanggal_jam_kunjungan | Waktu kunjungan | 2026-10-12 09:15 | Diisi otomatis (AB-02) | Petugas pendaftaran |
| keluhan | Keluhan pasien | Demam 3 hari | Data kesehatan, akses terbatas (AB-09) | Dokter |
| diagnosis | Hasil diagnosis dokter | Infeksi saluran pernapasan atas | Data kesehatan, akses terbatas (AB-09) | Dokter |
| kode_tindakan | Kode tindakan | TD-01 | Unik | Admin klinik |
| nama_tindakan | Nama tindakan | Pemeriksaan umum | Wajib diisi | Admin klinik |
| tarif_tindakan | Tarif terkini di daftar tindakan | 40000 | Bilangan bulat >= 0 (rupiah) | Admin klinik |
| tarif_saat_tindakan | Tarif pada saat tindakan | 40000 | Bilangan bulat >= 0, tidak berubah (AB-04) | Dokter |
| kode_obat | Kode obat | OB-015 | Unik | Apoteker |
| nama_obat | Nama obat | Paracetamol 500 mg | Wajib diisi | Apoteker |
| harga_jual_obat | Harga jual terkini | 1000 | Bilangan bulat >= 0 (rupiah) | Apoteker |
| stok_obat | Jumlah obat tersedia | 120 | Bilangan bulat >= 0 (AB-05) | Apoteker |
| batas_minimum_stok_obat | Batas pemicu pemesanan ulang | 30 | Bilangan bulat >= 0 | Apoteker |
| tanggal_kedaluwarsa_obat | Tanggal kedaluwarsa | 2027-08-31 | Tidak diserahkan bila lewat (AB-06) | Apoteker |
| qty_obat_resep | Jumlah obat pada satu baris resep | 10 | Bilangan bulat > 0, maksimal 4 baris per resep (AB-03) | Dokter |
| harga_satuan_resep | Harga obat saat resep | 1000 | Bilangan bulat >= 0, tidak berubah (AB-04) | Apoteker |
| aturan_pakai | Aturan pemakaian obat | 3 x 1 sesudah makan | Wajib diisi | Dokter |
| jumlah_bayar | Jumlah yang dibayar | 85000 | Sama dengan total tagihan (AB-07) | Kasir |
| tanggal_bayar | Waktu pembayaran | 2026-10-12 09:50 | Diisi otomatis | Kasir |
| metode_bayar | Cara pembayaran | Tunai | Nilai tunai atau transfer | Kasir |
| denda_keterlambatan | Denda tagihan terlambat | 4000 | Rp2.000 per hari setelah hari ke-7 (AB-08) | Kasir |

## 9. Kebutuhan non-fungsional data

**Perhitungan parameter P**

- NIM 25430028, dua digit terakhir = 28
- 28 mod 9 = 1 (karena 28 = 3 x 9 + 1)
- P = 1 + 1 = **2**
- Batas maksimal item per transaksi = P + 2 = **4** (AB-03)
- Denda keterlambatan = P ribu rupiah = **Rp2.000 per hari** (AB-08)
- Perkiraan volume harian = 40 + 5 x P = **50 kunjungan per hari**

**Volume dan retensi:** perkiraan 50 kunjungan per hari; data kunjungan dan pembayaran disimpan minimal 5 tahun (ditetapkan klinik).

**Data pribadi dan akses:** data kesehatan (keluhan, diagnosis) termasuk data pribadi yang bersifat spesifik sehingga akses dibatasi, sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

| Data | Boleh dilihat oleh |
|---|---|
| NIK, no. HP, alamat pasien | Petugas pendaftaran, kepala klinik |
| Keluhan dan diagnosis | Dokter yang menangani, kepala klinik |
| Tarif, harga, jumlah bayar | Kasir, admin klinik, kepala klinik |
| Stok dan kedaluwarsa obat | Apoteker, admin klinik, kepala klinik |

## 10. Isu kualitas data yang diantisipasi

1. **Duplikasi pasien:** satu orang punya dua no. RM karena lupa nomor atau salah ketik NIK. Pencegahan: AB-01 dan pencarian lewat NIK.
2. **Akurasi historis:** tarif dan harga obat berubah sehingga catatan lama salah. Pencegahan: AB-04.
3. **Konsistensi stok:** stok negatif atau obat kedaluwarsa terserahkan. Pencegahan: AB-05 dan AB-06.
4. **Keseragaman diagnosis:** diagnosis ditulis bebas sehingga laporan "diagnosis terbanyak" (KI-02) tidak konsisten. Perlu daftar diagnosis baku.
5. **Kelengkapan:** keluhan, diagnosis, atau no. HP kosong atau salah format.
6. **Kebocoran data kesehatan:** petugas yang tidak berwenang membaca diagnosis. Pencegahan: AB-09 dan pembatasan akses.
