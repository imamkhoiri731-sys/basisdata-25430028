# MODUL 4 — NORMALISASI BASIS DATA KOPMA

**Nama:** Imam Khoiri
**NIM:** 25430028
**Proyek:** Sistem Informasi Koperasi Mahasiswa (Kopma)

## 1. Tujuan

Normalisasi dilakukan untuk mengurangi redundansi data, mencegah anomali tambah, ubah, dan hapus, serta menghasilkan struktur tabel yang konsisten. Proses dilakukan dari UNF hingga 3NF dan dilanjutkan dengan pemeriksaan BCNF.

## 2. Bentuk Awal: UNF (Unnormalized Form)

Pada bentuk UNF, satu nota penjualan dapat memiliki beberapa barang dalam satu grup berulang.

```text
NOTA_UNF (
    no_nota_penjualan,
    tgl_penjualan,
    kode_petugas,
    nama_petugas,
    no_anggota,
    nama_anggota,
    {
        kode_barang,
        nama_barang,
        qty_detail_penjualan,
        harga_satuan_detail_penjualan,
        subtotal_detail_penjualan
    },
    jumlah_penjualan,
    diskon_penjualan,
    total_penjualan
)
```

**Masalah UNF:**
- Satu nota dapat menyimpan beberapa barang dalam grup berulang.
- Data petugas dan anggota dapat berulang pada banyak baris.
- Perubahan data yang tidak dilakukan secara konsisten dapat menyebabkan anomali.

## 3. Bentuk Normal Pertama (1NF)

Pada 1NF, grup berulang dihilangkan dengan membuat satu baris untuk setiap barang pada setiap nota. Setiap atribut berisi satu nilai atomik.

```text
NOTA_1NF (
    no_nota_penjualan,
    kode_barang,
    tgl_penjualan,
    kode_petugas,
    nama_petugas,
    no_anggota,
    nama_anggota,
    nama_barang,
    qty_detail_penjualan,
    harga_satuan_detail_penjualan,
    subtotal_detail_penjualan,
    jumlah_penjualan,
    diskon_penjualan,
    total_penjualan
)
```

**Kunci primer komposit:**
`(no_nota_penjualan, kode_barang)`

Dengan 1NF, grup barang yang berulang sudah dihilangkan. Namun, atribut seperti nama barang masih bergantung pada sebagian kunci komposit sehingga perlu dipisahkan pada tahap berikutnya.

## 4. Dependensi Fungsional

Dependensi fungsional (FD) menunjukkan hubungan antara atribut penentu dan atribut yang nilainya ditentukan. Identifikasi FD dilakukan berdasarkan struktur data dan aturan bisnis pada dokumen P02.

| Kode | Dependensi fungsional | Dasar dan penjelasan |
|---|---|---|
| FD1 | `no_nota_penjualan → tgl_penjualan, kode_petugas, no_anggota` | Nomor nota mengidentifikasi satu transaksi penjualan. `no_anggota` boleh bernilai kosong untuk pembeli umum (AB-01 dan AB-02). |
| FD2 | `kode_petugas → nama_petugas` | Kode petugas mengidentifikasi petugas yang bersangkutan. |
| FD3 | `no_anggota → nama_anggota` | Nomor anggota mengidentifikasi satu anggota. NIM juga harus unik (AB-05). |
| FD4 | `kode_barang → nama_barang` | Kode barang mengidentifikasi satu barang. |
| FD5 | `(no_nota_penjualan, kode_barang) → qty_detail_penjualan, harga_satuan_detail_penjualan` | Setiap barang pada suatu nota memiliki kuantitas dan harga transaksi sendiri. Harga disimpan pada detail agar riwayat harga tidak berubah (AB-04). |
| FD6 | `(qty_detail_penjualan, harga_satuan_detail_penjualan) → subtotal_detail_penjualan` | Subtotal merupakan nilai turunan dari kuantitas dikalikan harga satuan, bukan atribut yang harus disimpan secara terpisah. |

FD2 dan FD4 merupakan asumsi identifikasi berdasarkan kode unik pada entitas petugas dan barang; keunikannya perlu dipastikan pada skema data. FD3 mengikuti identitas anggota yang digunakan dalam aturan AB-05. FD5 mengikuti AB-04. FD1 mengasumsikan setiap nomor nota mengidentifikasi satu transaksi dengan tanggal dan petugas yang terkait.

AB-02 juga mengatur diskon 5% untuk anggota aktif. AB-03 dan AB-06 mengatur validasi stok dan pemesanan, sedangkan AB-07 sampai AB-10 mengatur poin loyalitas serta penerimaan pembelian. Aturan tersebut perlu diterapkan dalam rancangan sistem, tetapi tidak otomatis menjadi dependensi fungsional pada tabel NOTA_1NF.

## 5. Bentuk Normal Kedua (2NF)

2NF mensyaratkan bahwa relasi sudah memenuhi 1NF dan tidak memiliki ketergantungan parsial, yaitu atribut bukan kunci yang bergantung hanya pada sebagian kunci komposit.

Dari NOTA_1NF, data dipisahkan menjadi tabel berikut.

### 5.1 Tabel PENJUALAN
```text
PENJUALAN (
    no_nota_penjualan [PK],
    tgl_penjualan,
    kode_petugas [FK],
    no_anggota [FK, NULLABLE],
    bayar_penjualan
)
```

Tabel ini menyimpan informasi utama transaksi penjualan.

### 5.2 Tabel DETAIL_PENJUALAN

```text
DETAIL_PENJUALAN (
    no_nota_penjualan [PK, FK],
    kode_barang [PK, FK],
    qty_detail_penjualan,
    harga_satuan_detail_penjualan
)
```

Kunci primer kompositnya adalah `(no_nota_penjualan, kode_barang)`.

### 5.3 Tabel BARANG

```text
BARANG (
    kode_barang [PK],
    nama_barang,
    kategori_barang,
    harga_jual_barang,
    stok_barang,
    stok_min_barang
)
```

Tabel BARANG menyimpan identitas dan informasi barang. Harga jual saat ini disimpan terpisah dari harga satuan transaksi yang tercatat di DETAIL_PENJUALAN.

## 6. Bentuk Normal Ketiga (3NF)

3NF mensyaratkan bahwa relasi sudah memenuhi 2NF dan tidak memiliki ketergantungan transitif atribut bukan kunci terhadap kunci primer.

Pada tabel PENJUALAN, terdapat dependensi:

```text
no_nota_penjualan → kode_petugas → nama_petugas
no_nota_penjualan → no_anggota → nama_anggota
```

Oleh karena itu, data petugas dan anggota dipisahkan menjadi tabel tersendiri.

### 6.1 Tabel PETUGAS

```text
PETUGAS (
    kode_petugas [PK],
    nama_petugas,
    peran_petugas
)
```

### 6.2 Tabel ANGGOTA

```text
ANGGOTA (
    no_anggota [PK],
    nim_anggota,
    nama_anggota,
    prodi_anggota,
    no_hp_anggota,
    status_anggota,
    tgl_daftar_anggota
)
```
Dengan pemisahan ini, perubahan nama petugas atau anggota cukup dilakukan pada tabel asalnya. Data yang berulang dalam transaksi tidak perlu diperbarui satu per satu.

## 7. Skema Relasional Hasil Normalisasi

Skema inti hasil normalisasi disesuaikan dengan skema kanonik Kopma pada buku praktikum. Kunci primer menggunakan surrogate key `id_*`, sedangkan kode atau nomor alami digunakan sebagai kunci unik jika ditentukan oleh aturan bisnis.

1. `PETUGAS(id_petugas PK, kode_petugas UNIQUE, nama_petugas, peran_petugas)`
2. `ANGGOTA(id_anggota PK, no_anggota UNIQUE, nim_anggota UNIQUE, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota)`
3. `BARANG(id_barang PK, kode_barang UNIQUE, nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang)`
4. `PEMASOK(id_pemasok PK, nama_pemasok, telepon_pemasok, alamat_pemasok)`
5. `PENJUALAN(id_penjualan PK, no_nota_penjualan UNIQUE, tgl_penjualan, id_petugas FK, id_anggota FK NULL, bayar_penjualan)`
6. `DETAIL_PENJUALAN(id_penjualan PK/FK, id_barang PK/FK, qty_detail_penjualan, harga_satuan_detail_penjualan)`
7. `PEMBELIAN(id_pembelian PK, no_faktur_pembelian, id_pemasok FK, tgl_pembelian, status_pembelian)`
8. `DETAIL_PEMBELIAN(id_pembelian PK/FK, id_barang PK/FK, qty_detail_pembelian, harga_beli_detail_pembelian)`

Keterangan: PK adalah primary key, FK adalah foreign key, UNIQUE menunjukkan nilai yang tidak boleh berulang, dan NULL menunjukkan atribut yang boleh kosong. Pada PENJUALAN, `id_anggota` boleh kosong karena transaksi dapat dilakukan oleh pembeli umum.

Tabel DETAIL_PENJUALAN memiliki kunci primer komposit `(id_penjualan, id_barang)`. Tabel DETAIL_PEMBELIAN memiliki kunci primer komposit `(id_pembelian, id_barang)`. Kedua tabel tersebut menyimpan informasi yang bergantung pada pasangan transaksi dan barang.

ERD proyek juga memuat `MUTASI_POIN` untuk pencatatan perubahan poin anggota. Entitas ini merupakan bagian dari cakupan sistem Kopma, tetapi tidak termasuk dalam delapan tabel skema kanonik yang digunakan untuk menjelaskan normalisasi penjualan pada buku. Atribut dan relasinya tetap perlu dipertahankan dalam ERD proyek.

Latihan beberapa nomor telepon pemasok dibahas secara terpisah pada bagian 10. Jika latihan diterapkan pada ERD, relasi `TELEPON_PEMASOK` perlu ditambahkan dan perubahan tersebut dicatat pada bagian 12.

Catatan: Pastikan atribut dan relasi pada daftar ini cocok dengan diagram ERD final. Skema kanonik menjadi acuan normalisasi, sedangkan atribut tambahan mengikuti kebutuhan proyek yang telah ditetapkan.

## 8. Pemeriksaan BCNF

Boyce-Codd Normal Form (BCNF) mensyaratkan bahwa setiap determinan pada dependensi fungsional nontrivial merupakan superkey. Pemeriksaan dilakukan berdasarkan kunci primer, atribut unik, dan dependensi fungsional yang telah diidentifikasi.

| Tabel | Determinan yang diperiksa | Hasil pemeriksaan |
|---|---|---|
| PETUGAS | `id_petugas`, `kode_petugas` | Memenuhi BCNF apabila keduanya menentukan seluruh atribut petugas dan `kode_petugas` ditetapkan unik. |
| ANGGOTA | `id_anggota`, `no_anggota`, `nim_anggota` | Memenuhi BCNF apabila setiap determinan menentukan seluruh atribut anggota dan nomor anggota serta NIM ditetapkan unik. |
| BARANG | `id_barang`, `kode_barang` | Memenuhi BCNF apabila keduanya menentukan seluruh atribut barang dan `kode_barang` ditetapkan unik. |
| PEMASOK | `id_pemasok` | Memenuhi BCNF apabila ID pemasok menentukan seluruh atribut pemasok dan tidak terdapat determinan non-superkey lainnya. |
| PENJUALAN | `id_penjualan`, `no_nota_penjualan` | Memenuhi BCNF apabila keduanya menentukan seluruh atribut penjualan dan nomor nota ditetapkan unik. |
| DETAIL_PENJUALAN | `(id_penjualan, id_barang)` | Memenuhi BCNF apabila pasangan tersebut menentukan kuantitas dan harga satuan transaksi serta tidak terdapat determinan non-superkey lainnya. |
| PEMBELIAN | `id_pembelian` | Memenuhi BCNF apabila ID pembelian menentukan seluruh atribut pembelian dan tidak terdapat determinan non-superkey lainnya. |
| DETAIL_PEMBELIAN | `(id_pembelian, id_barang)` | Memenuhi BCNF apabila pasangan tersebut menentukan kuantitas dan harga beli detail serta tidak terdapat determinan non-superkey lainnya. |

Kunci pengganti (`id_*`) tidak otomatis menjamin suatu tabel memenuhi BCNF. Atribut unik alami dan seluruh dependensi fungsional pada setiap tabel tetap perlu diperiksa. Apabila ditemukan determinan yang bukan superkey, struktur tabel perlu dianalisis dan diperbaiki berdasarkan dependensi tersebut.

Entitas `MUTASI_POIN` pada ERD proyek tidak termasuk dalam delapan tabel yang diperiksa pada bagian ini. Normalisasi tabel tersebut perlu dianalisis secara terpisah berdasarkan atribut dan aturan bisnis mutasi poin yang berlaku.

**Kesimpulan:** berdasarkan informasi yang telah diidentifikasi, pemeriksaan BCNF masih memerlukan verifikasi terhadap seluruh dependensi fungsional pada setiap tabel. Oleh karena itu, status BCNF akhir belum dapat dipastikan hanya dari daftar kunci primer dan atribut unik.

## 9. Analisis Normalisasi

### 9.1 Mengapa harga transaksi tidak bergantung pada kode barang saja?

Harga satuan pada nota merupakan harga ketika transaksi berlangsung. Harga tersebut dapat berbeda dari harga jual barang saat ini. Jika harga transaksi hanya disimpan di tabel BARANG, perubahan harga akan memengaruhi informasi transaksi lama dan menyebabkan laporan omzet historis tidak akurat.

Karena itu, `harga_satuan_detail_penjualan` disimpan di DETAIL_PENJUALAN.

### 9.2 Keputusan penyimpanan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| `subtotal_detail_penjualan` | Dihitung | Diperoleh dari kuantitas dikalikan harga satuan. |
| `jumlah_penjualan` | Dihitung | Diperoleh dari penjumlahan subtotal detail. |
| `total_penjualan` | Dihitung | Dapat diperoleh dari jumlah penjualan dikurangi diskon yang berlaku. |
| Kembalian | Dihitung | Diperoleh dari uang pembayaran dikurangi total transaksi. |

Nilai turunan tidak disimpan sebagai kolom operasional pada skema ini agar tidak terjadi ketidaksesuaian antara hasil perhitungan dan data rinci transaksi. Keputusan ini mengikuti pendekatan dalam buku praktikum.

### 9.3 Informasi pemasok barang

Informasi pemasok tidak ditempatkan langsung pada tabel BARANG. Hubungan pemasok dan barang diperoleh melalui riwayat pembelian dan detail pembelian.

Keuntungannya adalah Kopma dapat membeli barang dari pemasok yang berbeda pada waktu berbeda tanpa harus mengubah data identitas barang.

## 10. Latihan dan Modifikasi

### 10.1 Beberapa nomor telepon untuk satu pemasok

Jika satu pemasok dapat memiliki beberapa nomor telepon, atribut nomor telepon dipisahkan ke dalam relasi baru bernama `TELEPON_PEMASOK`.

```text
TELEPON_PEMASOK (
    id_pemasok [PK, FK],
    no_telepon_pemasok [PK]
)
```

Kunci primer komposit `(id_pemasok, no_telepon_pemasok)` memastikan setiap nomor telepon tercatat untuk pemasok yang sesuai. Atribut `id_pemasok` juga menjadi foreign key yang mengacu pada tabel PEMASOK.

Perubahan ini merupakan usulan hasil latihan. Relasi tersebut perlu ditambahkan ke ERD jika aturan beberapa nomor telepon diterapkan pada rancangan akhir.

### 10.2 Anomali ubah nama anggota

Apabila `nama_anggota` disimpan berulang pada setiap transaksi penjualan, perubahan nama dapat menimbulkan ketidakkonsistenan jika tidak semua baris diperbarui. Kondisi tersebut merupakan contoh anomali pembaruan pada struktur yang belum dinormalisasi.
Contoh tersebut hanya menggambarkan anomali pada struktur sebelum normalisasi dan bukan perintah yang dijalankan pada skema akhir.

Contoh SQL berikut hanya merupakan ilustrasi untuk struktur yang masih menyimpan nama anggota di tabel penjualan:

```sql
UPDATE penjualan
SET nama_anggota = 'Nama Baru'
WHERE no_anggota = 'AG001';
```
Pada skema hasil normalisasi, `nama_anggota` disimpan di tabel ANGGOTA, sedangkan tabel PENJUALAN menyimpan foreign key `id_anggota`. Oleh karena itu, perubahan nama dilakukan pada tabel ANGGOTA saja, sehingga tidak perlu memperbarui setiap transaksi anggota tersebut.

## 11. Kesimpulan

Normalisasi mengubah struktur data penjualan dari bentuk UNF menjadi 1NF, 2NF, dan 3NF dengan menghilangkan grup berulang, ketergantungan parsial, dan ketergantungan transitif. Skema hasil normalisasi memisahkan data petugas, anggota, barang, pemasok, transaksi, dan detail transaksi. Pemeriksaan BCNF dilakukan berdasarkan dependensi fungsional yang telah diidentifikasi. Nilai turunan dihitung agar data operasional tetap konsisten.

## 12. Dokumentasi Perubahan ERD

ERD Kopma yang diperiksa telah memuat entitas PETUGAS, ANGGOTA, BARANG, PEMASOK, PENJUALAN, DETAIL_PENJUALAN, PEMBELIAN, DETAIL_PEMBELIAN, dan MUTASI_POIN.

Hasil pemeriksaan terhadap diagram menunjukkan hal-hal berikut:

1. DETAIL_PENJUALAN menggunakan pasangan kunci primer dan foreign key `(id_penjualan, id_barang)`.
2. DETAIL_PEMBELIAN menggunakan pasangan kunci primer dan foreign key `(id_pembelian, id_barang)`.
3. MUTASI_POIN memiliki `id_mutasi_poin` sebagai primary key dan `id_penjualan` sebagai foreign key yang boleh kosong.
4. Tabel PEMASOK masih memuat atribut `telepon_pemasok`. Relasi TELEPON_PEMASOK belum ditemukan pada diagram yang diperiksa.

Latihan beberapa nomor telepon pemasok pada bagian 10.1 masih berupa usulan normalisasi dan belum tercermin dalam ERD. Jika aturan tersebut diterapkan, entitas TELEPON_PEMASOK perlu ditambahkan dengan kunci primer komposit `(id_pemasok, no_telepon_pemasok)`.

**Status:** Struktur kunci pada tabel detail telah diperiksa. Penyesuaian ERD berdasarkan seluruh hasil normalisasi, termasuk kemungkinan penambahan TELEPON_PEMASOK, masih perlu diputuskan dan diterapkan sebelum dokumentasi dinyatakan final.
