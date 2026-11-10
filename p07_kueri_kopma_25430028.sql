-- =====================================================================
-- p07_kueri_kopma_25430028.sql  |  Modul 7: SELECT dan Fungsi Skalar (Kopma)
-- Basis data: kopma_028 (NIM 25430028)
-- =====================================================================
USE kopma_028;

-- ---------------------------------------------------------------------
-- D.1 langkah 1: KI-03 barang yang perlu dipesan ulang
-- Harapan:
-- Roti Cokelat diperkirakan muncul karena stoknya 6, sedangkan stok
-- minimumnya 10. Jumlah kekurangannya 4.
-- ---------------------------------------------------------------------

SELECT kode_barang, nama_barang, stok_barang, stok_min_barang,
       stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_barang < stok_min_barang
ORDER BY kurang DESC;

-- ---------------------------------------------------------------------
-- D.1 langkah 2a: barang kategori ATK atau minuman (IN)
-- Harapan:
-- Diperkirakan muncul 3 barang, yaitu Pulpen Gel 0.5, Buku Tulis 58,
-- dan Air Mineral 600. Roti Cokelat tidak ikut tampil karena kategorinya
-- makanan.
-- ---------------------------------------------------------------------

SELECT kode_barang, nama_barang, kategori_barang, harga_jual_barang
FROM barang
WHERE kategori_barang IN ('ATK', 'minuman')
ORDER BY kategori_barang, nama_barang;

-- ---------------------------------------------------------------------
-- D.1 langkah 2b: nota pada rentang tanggal (BETWEEN)
-- Harapan:
-- Nota PJ-2609-0142 diperkirakan muncul karena tanggal transaksinya
-- 24 September 2026 pukul 10:15. Nota di luar tanggal 24–25 September
-- 2026 tidak akan ditampilkan.
-- ---------------------------------------------------------------------

SELECT no_nota_penjualan, tgl_penjualan, bayar_penjualan
FROM penjualan
WHERE tgl_penjualan BETWEEN '2026-09-24 00:00:00' AND '2026-09-25 23:59:59'
ORDER BY tgl_penjualan;

-- ---------------------------------------------------------------------
-- D.1 langkah 2c: anggota tanpa nomor HP (IS NULL)
-- Harapan:
-- Menampilkan anggota yang nomor HP-nya masih NULL. Nama dan jumlah
-- anggota yang muncul akan disesuaikan dengan data yang sudah dimasukkan.
-- ---------------------------------------------------------------------

SELECT no_anggota, nama_anggota, no_hp_anggota
FROM anggota
WHERE no_hp_anggota IS NULL;

-- ---------------------------------------------------------------------
-- Titik Analisis 1:
-- (a) Harapan:
-- Diperkirakan muncul ERROR 1054 karena alias 'kurang' tidak bisa
-- langsung digunakan pada bagian WHERE.
-- ---------------------------------------------------------------------

SELECT kode_barang, stok_min_barang - stok_barang AS kurang
FROM barang
WHERE kurang > 0;

-- (b) Versi setara tanpa alias
-- Harapan:
-- Kueri berhasil dijalankan dan menampilkan barang yang stoknya
-- di bawah stok minimum beserta jumlah kekurangannya.
-- ---------------------------------------------------------------------
SELECT kode_barang, stok_min_barang - stok_barang AS kurang
FROM barang
WHERE stok_min_barang - stok_barang > 0;

-- ---------------------------------------------------------------------
-- D.2 langkah 3: label anggota
-- Harapan:
-- Menampilkan maksimal 5 anggota yang namanya mengandung huruf 'a'.
-- Hasil diurutkan dari tanggal daftar paling baru ke paling lama.
-- Tanggal ditampilkan dalam format DD-MM-YYYY, HP kosong diganti '-',
-- dan status aktif mendapat keterangan Diskon 5%.
-- ---------------------------------------------------------------------

SELECT CONCAT(nama_anggota, ' (', no_anggota, ')')      AS anggota,
       DATE_FORMAT(tgl_daftar_anggota, '%d-%m-%Y')       AS tgl_daftar_anggota,
       IFNULL(no_hp_anggota, '-')                        AS hp,
       CASE status_anggota WHEN 'aktif' THEN 'Diskon 5%'
                           ELSE 'Tanpa diskon' END       AS keterangan
FROM anggota
WHERE nama_anggota LIKE '%a%'
ORDER BY tgl_daftar_anggota DESC
LIMIT 5;

-- ---------------------------------------------------------------------
-- Titik Analisis 2:
-- (a) Harapan:
-- Menghasilkan 0 baris karena NULL tidak bisa dibandingkan menggunakan
-- tanda sama dengan (=).
-- ---------------------------------------------------------------------

SELECT no_anggota, nama_anggota FROM anggota WHERE no_hp_anggota = NULL;

-- (b) Harapan:
-- Menampilkan anggota yang nomor HP-nya bernilai NULL karena
-- menggunakan IS NULL.
-- ---------------------------------------------------------------------

SELECT no_anggota, nama_anggota FROM anggota WHERE no_hp_anggota IS NULL;

-- ---------------------------------------------------------------------
-- D.3 langkah 4: lama keanggotaan
-- Harapan:
-- Menampilkan lama keanggotaan setiap anggota dalam hitungan hari.
-- Anggota dengan masa keanggotaan kurang dari 180 hari masuk kategori
-- baru, sedangkan 180 hari atau lebih masuk kategori lama.
-- Nilai hari mengikuti tanggal saat kueri dijalankan.
-- ---------------------------------------------------------------------

SELECT no_anggota, nama_anggota, tgl_daftar_anggota,
       DATEDIFF(CURDATE(), tgl_daftar_anggota) AS hari,
       IF(DATEDIFF(CURDATE(), tgl_daftar_anggota) < 180, 'baru', 'lama') AS kategori
FROM anggota;

-- ---------------------------------------------------------------------
-- D.3 langkah 5: subtotal nota PJ-2609-0142
-- Harapan:
-- Pulpen Gel 0.5 diperkirakan memiliki subtotal Rp12.000 dari
-- 3 barang dikali Rp4.000. Dua barang lainnya diperkirakan memiliki
-- total subtotal Rp17.000, sehingga jumlah seluruh nota menjadi
-- Rp29.000 sesuai catatan transaksi.
-- ---------------------------------------------------------------------

SELECT id_penjualan, id_barang, qty_detail_penjualan, harga_satuan_detail_penjualan,
       qty_detail_penjualan * harga_satuan_detail_penjualan AS subtotal
FROM detail_penjualan
WHERE id_penjualan = 1;
