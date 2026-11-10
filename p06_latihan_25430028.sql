-- =====================================================================
-- p06_latihan_25430028.sql  |  Modul 6: Latihan dan Modifikasi (E.1 dan E.2)
-- Basis data: kopma_028 (NIM 25430028)
-- Urutan menjalankan dari nol:
--   1. p05_ddl_25430028.sql        (DDL Kopma)
--   2. p06_data_kopma_25430028.sql (data Kopma)
--   3. p06_latihan_25430028.sql    (berkas ini)
-- =====================================================================
USE kopma_028;

-- ---------------------------------------------------------------------
-- E.1 Pindahkan anggota nonaktif yang mendaftar sebelum 2025 ke anggota_arsip
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS anggota_arsip;

-- Data uji pengaman: anggota nonaktif lama yang MASIH punya penjualan.
-- Anggota ini tidak boleh ikut diarsipkan atau dihapus.
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota, tgl_daftar_anggota)
VALUES ('A-0005','2343001005','Eka Saputra','Teknik Informatika',
        '081234560005','nonaktif','2024-10-12');

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas,
                       id_anggota, bayar_penjualan)
SELECT 'PJ-2503-0007', '2025-03-15 10:00:00', 1, id_anggota, 4000
FROM anggota WHERE no_anggota = 'A-0005';

INSERT INTO detail_penjualan (id_penjualan, id_barang,
                              qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT id_penjualan, 3, 1, 4000
FROM penjualan WHERE no_nota_penjualan = 'PJ-2503-0007';

-- Tabel arsip dengan struktur sama, lalu salin yang memenuhi syarat
CREATE TABLE anggota_arsip LIKE anggota;

INSERT INTO anggota_arsip
SELECT * FROM anggota
WHERE status_anggota = 'nonaktif'
  AND tgl_daftar_anggota < '2025-01-01'
  AND id_anggota NOT IN (SELECT id_anggota FROM penjualan
                         WHERE id_anggota IS NOT NULL);

-- Hapus dari tabel asal hanya yang sudah masuk arsip
DELETE FROM anggota
WHERE id_anggota IN (SELECT id_anggota FROM anggota_arsip);

-- Pemeriksaan: arsip berisi Dwi Anggoro; anggota berisi Aulia, Bagas,
-- Citra, dan Eka (Eka tetap ada karena masih punya penjualan)
SELECT * FROM anggota_arsip;
SELECT id_anggota, no_anggota, nama_anggota, status_anggota, tgl_daftar_anggota
FROM anggota;

-- ---------------------------------------------------------------------
-- E.2 Naikkan harga barang kategori makanan 5%, dibulatkan ke ratusan terdekat
-- (id_barang > 0 agar lolos mode aman sql_safe_updates)
-- ---------------------------------------------------------------------
UPDATE barang
SET harga_jual_barang = ROUND(harga_jual_barang * 1.05, -2)
WHERE kategori_barang = 'makanan' AND id_barang > 0;

SELECT kode_barang, nama_barang, harga_jual_barang
FROM barang WHERE kategori_barang = 'makanan';
