-- =====================================================================
-- p07_kueri_25430028.sql
-- Modul 7: Kueri SELECT Proyek Klinik
-- NIM: 25430028
-- Basis data: klinik_028
-- =====================================================================

USE klinik_028;

-- KI-01: Menampilkan data pasien dengan format nama kapital dan tanggal lahir rapi
SELECT id_pasien, UPPER(nama_pasien) AS nama_pasien_kapital, 
       DATE_FORMAT(tgl_lahir_pasien, '%d-%m-%Y') AS tgl_lahir, jenis_kelamin_pasien
FROM pasien;

-- KI-02: Menampilkan data dokter dan spesialisasinya
SELECT id_dokter, nama_dokter, spesialis_dokter, no_telp_dokter
FROM dokter
ORDER BY spesialis_dokter, nama_dokter;

-- KI-03: Menampilkan daftar poli
SELECT id_poli, nama_poli
FROM poli;

-- KI-04: Menampilkan daftar tindakan dengan format harga rupiah
SELECT id_tindakan, nama_tindakan, 
       CONCAT('Rp', FORMAT(biaya_tindakan, 0, 'id_ID')) AS biaya_formatted
FROM tindakan
WHERE biaya_tindakan > 50000;

-- KI-05: Menampilkan data obat yang stoknya menipis (di bawah 10)
SELECT kode_obat, nama_obat, stok_obat, harga_jual_obat,
       10 - stok_obat AS kekurangan_stok
FROM obat
WHERE stok_obat < 10
ORDER BY kekurangan_stok DESC;

-- KI-06: Menampilkan data kunjungan terbaru pada rentang waktu tertentu
SELECT no_kunjungan, tgl_kunjungan, keluhan_kunjungan
FROM kunjungan
WHERE tgl_kunjungan BETWEEN '2026-09-01 00:00:00' AND '2026-09-30 23:59:59'
ORDER BY tgl_kunjungan DESC;

-- KI-07: Menampilkan data resep
SELECT id_resep, id_kunjungan, aturan_pakai_resep
FROM resep;

-- KI-08: Menampilkan data pembayaran dengan status diskon kondisional (CASE)
SELECT id_pembayaran, total_pembayaran,
       CASE WHEN total_pembayaran >= 200000 THEN 'Diskon 10%'
            ELSE 'Tanpa Diskon' END AS keterangan_diskon
FROM pembayaran;

-- KI-09: Menampilkan data pemasok yang memiliki nomor telepon terdaftar (IS NULL check)
SELECT id_pemasok, nama_pemasok, IFNULL(telp_pemasok, 'Tidak Ada Telepon') AS telepon
FROM pemasok;

-- KI-10: Menampilkan data pembelian obat terbaru dengan batas limit
SELECT id_pembelian, no_faktur_pembelian, tgl_pembelian, status_pembelian
FROM pembelian_obat
ORDER BY tgl_pembelian DESC
LIMIT 5;

-- =====================================================================
-- SELESAI
-- =====================================================================