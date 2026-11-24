-- =====================================================================
-- p09_agregasi_kopma_25430028.sql  |  Modul 9: Agregat dan GROUP BY
-- Basis data: kopma_028 (NIM 25430028)
-- Prasyarat : kopma_data_lanjutan.sql sudah dimuat (75 nota)
-- =====================================================================
USE kopma_028;

-- ---------------------------------------------------------------------
-- Langkah 1-2: aktifkan mode ketat (berlaku untuk sesi ini saja)
-- ---------------------------------------------------------------------
SET SESSION sql_mode = CONCAT(@@sql_mode, ',ONLY_FULL_GROUP_BY');

-- Hasil diharapkan: 75 nota, 2 September s.d. 31 Oktober 2026
SELECT COUNT(*) AS nota,
       MIN(tgl_penjualan) AS awal,
       MAX(tgl_penjualan) AS akhir
FROM penjualan;

-- ---------------------------------------------------------------------
-- Langkah 3: total satu nota (pertanyaan tertunda dari Modul 7)
-- ---------------------------------------------------------------------
SELECT p.no_nota_penjualan,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS jumlah
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.no_nota_penjualan = 'PJ-2609-0001'
GROUP BY p.id_penjualan, p.no_nota_penjualan;

-- Titik Analisis 1: (diisi sendiri di laporan setelah mencoba galat 1055)

-- ---------------------------------------------------------------------
-- Langkah 4: KI-01 omzet harian minggu pertama September + ROLLUP
-- ---------------------------------------------------------------------
SELECT DATE(p.tgl_penjualan) AS tanggal,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
WHERE p.tgl_penjualan >= '2026-09-01' AND p.tgl_penjualan < '2026-09-08'
GROUP BY DATE(p.tgl_penjualan) WITH ROLLUP;

-- ---------------------------------------------------------------------
-- Langkah 5: KI-01 omzet per bulan
-- Hasil diharapkan: September 39 nota (Rp691.000), Oktober 36 nota (Rp507.500)
-- ---------------------------------------------------------------------
SELECT DATE_FORMAT(p.tgl_penjualan, '%Y-%m') AS bulan,
       COUNT(DISTINCT p.id_penjualan) AS nota,
       SUM(d.qty_detail_penjualan * d.harga_satuan_detail_penjualan) AS omzet
FROM penjualan p
JOIN detail_penjualan d ON d.id_penjualan = p.id_penjualan
GROUP BY DATE_FORMAT(p.tgl_penjualan, '%Y-%m') WITH ROLLUP;

-- Titik Analisis 2: (bandingkan COUNT(DISTINCT p.id_penjualan) dengan COUNT(*))

-- ---------------------------------------------------------------------
-- Langkah 6: HAVING
-- ---------------------------------------------------------------------
-- (a) kasir yang melayani lebih dari 20 nota
SELECT pt.kode_petugas, pt.nama_petugas, COUNT(*) AS nota
FROM penjualan p
JOIN petugas pt ON pt.id_petugas = p.id_petugas
GROUP BY pt.id_petugas, pt.kode_petugas, pt.nama_petugas
HAVING COUNT(*) > 20;

-- (b) barang dengan total qty terjual kurang dari 10
SELECT b.kode_barang, b.nama_barang,
       SUM(d.qty_detail_penjualan) AS total_qty
FROM barang b
JOIN detail_penjualan d ON d.id_barang = b.id_barang
GROUP BY b.id_barang, b.kode_barang, b.nama_barang
HAVING SUM(d.qty_detail_penjualan) < 10;

-- Titik Analisis 3: rata-rata belanja per nota untuk anggota saja
-- (ditulis sendiri setelah memahami urutan evaluasi WHERE vs HAVING)

-- ---------------------------------------------------------------------
-- Latihan E (dikerjakan setelah langkah D selesai)
-- ---------------------------------------------------------------------
-- E.1 : (belum dikerjakan)
-- E.2 : (belum dikerjakan)
