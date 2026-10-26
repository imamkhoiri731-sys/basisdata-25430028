-- =====================================================================
-- p05_latihan_25430028.sql  |  Modul 5, Bab E: Latihan dan Modifikasi
-- Basis data: kopma_028 (NIM 25430028)
-- Dijalankan SETELAH p05_ddl_25430028.sql. Skrip DDL tidak diubah;
-- perubahan latihan dicatat di berkas ini agar DDL tetap bisa diulang
-- dari basis data kosong.
-- Jalankan blok per blok: perintah bertanda [HARUS DITOLAK] sengaja gagal.
-- =====================================================================
USE kopma_028;

-- ---------------------------------------------------------------------
-- E.1  CHECK: stok_min_barang tidak boleh negatif
-- ---------------------------------------------------------------------
-- Data uji (agar UPDATE benar-benar mengenai satu baris)
INSERT INTO barang (kode_barang, nama_barang, kategori_barang, harga_jual_barang, stok_barang)
VALUES ('ATK-001', 'Pulpen Gel 0.5', 'ATK', 4000, 50);

ALTER TABLE barang ADD CONSTRAINT ck_barang_stokmin CHECK (stok_min_barang >= 0);

-- [HARUS DITOLAK] -> ERROR 4025 (ck_barang_stokmin)
UPDATE barang SET stok_min_barang = -1 WHERE id_barang = 1;

-- ---------------------------------------------------------------------
-- E.2  fk_penjualan_anggota: ON DELETE SET NULL
-- ---------------------------------------------------------------------
ALTER TABLE penjualan DROP FOREIGN KEY fk_penjualan_anggota;
ALTER TABLE penjualan
  ADD CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
  REFERENCES anggota (id_anggota) ON DELETE SET NULL;

SELECT CONSTRAINT_NAME, DELETE_RULE
FROM information_schema.REFERENTIAL_CONSTRAINTS
WHERE CONSTRAINT_SCHEMA = 'kopma_028' AND TABLE_NAME = 'penjualan';

-- ---------------------------------------------------------------------
-- E.2 (opsional)  Bukti perilaku SET NULL
-- ---------------------------------------------------------------------
INSERT INTO petugas (kode_petugas, nama_petugas, peran_petugas)
VALUES ('K01', 'Petugas Kasir Satu', 'kasir');

INSERT INTO anggota (no_anggota, nim_anggota, nama_anggota, prodi_anggota, tgl_daftar_anggota)
VALUES ('A-0001', '2543002801', 'Anggota Uji', 'Informatika', CURDATE());

INSERT INTO penjualan (no_nota_penjualan, tgl_penjualan, id_petugas, id_anggota, bayar_penjualan)
VALUES ('PJ-2610-0001', NOW(), 1, 1, 4000);

SELECT id_penjualan, no_nota_penjualan, id_anggota FROM penjualan;   -- id_anggota = 1

DELETE FROM anggota WHERE id_anggota = 1;

SELECT id_penjualan, no_nota_penjualan, id_anggota FROM penjualan;   -- id_anggota = NULL
