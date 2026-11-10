-- =====================================================================
-- p06_data_kopma_25430028.sql  |  Modul 6: Data Kopma (latihan langkah D)
-- Basis data: kopma_028 (NIM 25430028)
-- Jalankan SETELAH p05_ddl_25430028.sql (DDL sudah memuat DROP TABLE IF EXISTS,
-- sehingga AUTO_INCREMENT kembali ke 1 dan hasil selalu sama).
-- Urutan pengisian: INDUK dahulu, ANAK kemudian.
-- =====================================================================
USE kopma_028;

-- ---------------------------------------------------------------------
-- D.1 langkah 1: data induk petugas dan barang (sesuai buku)
-- id_petugas otomatis: K01=1, K02=2, K03=3 (Rina), G01=4, P01=5
-- ---------------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas) VALUES
  ('K01','Dimas','kasir'),
  ('K02','Sari','kasir'),
  ('K03','Rina','kasir'),
  ('G01','Joko','gudang'),
  ('P01','Ketua Kopma','ketua');

INSERT INTO barang (kode_barang, nama_barang, kategori_barang,
                    harga_jual_barang, stok_barang, stok_min_barang) VALUES
  ('ATK-001','Pulpen Gel 0.5','ATK',4000,120,20),
  ('ATK-002','Buku Tulis 58','ATK',6500,80,20),
  ('MNM-001','Air Mineral 600','minuman',4000,48,24),
  ('MKN-001','Roti Cokelat','makanan',5000,6,10);

-- ---------------------------------------------------------------------
-- D.1 langkah 2: anggota (min. 3, satu nonaktif) dan pemasok (min. 2)
-- id_anggota 1 = Aulia (dipakai nota contoh PJ-2609-0142)
-- Data fiktif: NIM dan nomor HP bukan milik orang sungguhan.
-- ---------------------------------------------------------------------
INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota,
                     no_hp_anggota, status_anggota, tgl_daftar_anggota) VALUES
  ('A-0001','2543001001','Aulia Rahmawati','Ilmu Komputer','081234560001','aktif','2025-08-18'),
  ('A-0002','2543001002','Bagas Prasetyo','Ilmu Komputer','081234560002','aktif','2025-08-18'),
  ('A-0003','2443001003','Citra Lestari','Pendidikan Matematika',NULL,'aktif','2025-02-10'),
  ('A-0004','2343001004','Dwi Anggoro','Teknik Informatika','081234560004','nonaktif','2024-09-05');

INSERT INTO pemasok (nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('CV Sinar Tulis Metro','072541001','Jl. Jend. Sudirman No. 12, Metro'),
  ('UD Berkah Pangan','072541002','Jl. Ki Hajar Dewantara No. 8, Metro'),
  ('PT Segar Nusantara Lampung','072541003','Jl. Soekarno-Hatta No. 45, Bandar Lampung');

-- ---------------------------------------------------------------------
-- D.2 langkah 3-4: nota contoh PJ-2609-0142 (Gambar 2.5 buku)
-- Kasir Rina (id_petugas 3), anggota Aulia (id_anggota 1), bayar 30.000
-- ---------------------------------------------------------------------
INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas,
                       id_anggota, bayar_penjualan)
VALUES ('PJ-2609-0142', '2026-09-24 10:15:00', 3, 1, 30000);

-- Harga satuan DISALIN dari tabel barang (AB-04), bukan diketik manual
INSERT INTO detail_penjualan (id_penjualan, id_barang,
                              qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 3, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-001';

INSERT INTO detail_penjualan (id_penjualan, id_barang,
                              qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 2, harga_jual_barang FROM barang WHERE kode_barang = 'ATK-002';

INSERT INTO detail_penjualan (id_penjualan, id_barang,
                              qty_detail_penjualan, harga_satuan_detail_penjualan)
SELECT 1, id_barang, 1, harga_jual_barang FROM barang WHERE kode_barang = 'MNM-001';

-- Kurangi stok sesuai qty (id_barang: 1=pulpen, 2=buku, 3=air mineral)
UPDATE barang SET stok_barang = stok_barang - 3 WHERE id_barang = 1;  -- 120 -> 117
UPDATE barang SET stok_barang = stok_barang - 2 WHERE id_barang = 2;  --  80 -> 78
UPDATE barang SET stok_barang = stok_barang - 1 WHERE id_barang = 3;  --  48 -> 47

-- ---------------------------------------------------------------------
-- Verifikasi jumlah baris
-- ---------------------------------------------------------------------
SELECT 'petugas' AS tabel, COUNT(*) AS jumlah_baris FROM petugas
UNION ALL SELECT 'barang',  COUNT(*) FROM barang
UNION ALL SELECT 'anggota', COUNT(*) FROM anggota
UNION ALL SELECT 'pemasok', COUNT(*) FROM pemasok;