-- =====================================================================
-- p06_data_25430028.sql  |  Milestone Proyek 6: Data Klinik IK Sehat
-- Basis data proyek: klinik_028 (NIM 25430028, tema klinik)
-- Parameter P = 2 -> maks. 4 baris per transaksi (AB-03), 50 kunjungan/hari
-- Jalankan SETELAH p05_ddl_klinik_25430028.sql (DDL memuat DROP TABLE IF EXISTS,
-- sehingga AUTO_INCREMENT kembali ke 1 dan hasil selalu sama).
-- Urutan: INDUK dahulu, TRANSAKSI kemudian. Semua data FIKTIF.
-- Kode AB-xx merujuk ke p02_kebutuhan_data_25430028.md.
-- =====================================================================
USE klinik_028;

-- ---------------------------------------------------------------------
-- 7a. DATA INDUK (setiap tabel induk minimal 5 baris)
-- ---------------------------------------------------------------------

-- Pasien (8 baris). NIK dan nomor HP fiktif.
INSERT INTO pasien (no_rm, nik_pasien, nama_pasien, tanggal_lahir_pasien,
                    jenis_kelamin_pasien, no_hp_pasien, alamat_pasien) VALUES
  ('RM-000123','1571010000000001','Budi Santoso',   '1990-05-14','L','081200000001','Jl. Kenanga No. 5, Jambi'),
  ('RM-000124','1571010000000002','Siti Aminah',    '1985-11-02','P','081200000002','Jl. Melati No. 12, Jambi'),
  ('RM-000125','1571010000000003','Andi Wijaya',    '2001-03-21','L','081200000003','Jl. Mawar No. 8, Jambi'),
  ('RM-000126','1571010000000004','Rina Marlina',   '1995-07-30','P','081200000004','Jl. Anggrek No. 3, Jambi'),
  ('RM-000127','1571010000000005','Dedi Kurniawan', '1978-01-09','L','081200000005','Jl. Cempaka No. 21, Jambi'),
  ('RM-000128','1571010000000006','Nadia Putri',    '2018-09-12','P','081200000006','Jl. Flamboyan No. 7, Jambi'),
  ('RM-000129','1571010000000007','Hasan Basri',    '1955-12-25','L','081200000007','Jl. Dahlia No. 14, Jambi'),
  ('RM-000130','1571010000000008','Lestari Dewi',   '1999-04-17','P','081200000008','Jl. Teratai No. 9, Jambi');

-- Dokter (5 baris)
INSERT INTO dokter (kode_dokter, no_str_dokter, nama_dokter, spesialisasi_dokter) VALUES
  ('DR-01','3174020001','dr. Ayu Lestari',          'Dokter Umum'),
  ('DR-02','3174020002','drg. Rudi Hartono',        'Dokter Gigi'),
  ('DR-03','3174020003','dr. Maya Puspita, Sp.OG',  'Kebidanan dan Kandungan'),
  ('DR-04','3174020004','dr. Fajar Nugroho, Sp.A',  'Kesehatan Anak'),
  ('DR-05','3174020005','dr. Hendra Wijaya',        'Dokter Umum');

-- Poli (5 baris; dokumen p02 menyebut umum, gigi, KIA; dua poli lain
-- ditambahkan agar memenuhi minimal 5 baris tabel induk)
INSERT INTO poli (kode_poli, nama_poli) VALUES
  ('PL-UM','Umum'),
  ('PL-GG','Gigi'),
  ('PL-KA','Kesehatan Ibu dan Anak'),
  ('PL-LN','Lansia'),
  ('PL-GZ','Gizi');

-- Tindakan (7 baris), tarif terkini
INSERT INTO tindakan (kode_tindakan, nama_tindakan, tarif_tindakan) VALUES
  ('TD-01','Pemeriksaan umum',        40000),
  ('TD-02','Cek suhu dan tensi',       5000),
  ('TD-03','Pemeriksaan gigi',        60000),
  ('TD-04','Pencabutan gigi',        150000),
  ('TD-05','Pemeriksaan kehamilan',   75000),
  ('TD-06','Imunisasi dasar',         50000),
  ('TD-07','Penjahitan luka',        120000);

-- Obat (8 baris). OB-008 sudah KEDALUWARSA (2026-10-31) dan OB-004 stoknya
-- di bawah batas minimum: dipakai untuk uji AB-05, AB-06 dan KI-03.
INSERT INTO obat (kode_obat, nama_obat, harga_jual_obat, stok_obat,
                  batas_minimum_stok_obat, tanggal_kedaluwarsa_obat) VALUES
  ('OB-001','Paracetamol 500 mg',      1000, 500, 100, '2027-08-31'),
  ('OB-002','Amoxicillin 500 mg',      2000, 300,  60, '2027-05-31'),
  ('OB-003','Ibuprofen 400 mg',        1500, 200,  50, '2027-03-31'),
  ('OB-004','Cetirizine 10 mg',        1200,  18,  40, '2027-06-30'),
  ('OB-005','Antasida tablet',          800, 250,  50, '2027-09-30'),
  ('OB-006','Vitamin C 500 mg',         700, 400,  80, '2028-01-31'),
  ('OB-007','Asam folat 400 mcg',       600, 180,  40, '2027-11-30'),
  ('OB-008','Sirup batuk 60 ml',       9000,  25,  10, '2026-10-31');

-- Pemasok (5 baris). PMS-03 sesuai contoh di kamus data.
INSERT INTO pemasok (kode_pemasok, nama_pemasok, telepon_pemasok, alamat_pemasok) VALUES
  ('PMS-01','PT Medika Jambi Sentosa',  '0741700001','Jl. Sultan Thaha No. 15, Jambi'),
  ('PMS-02','CV Apotek Mitra Husada',   '0741700002','Jl. Gatot Subroto No. 22, Jambi'),
  ('PMS-03','PT Sehat Farma',           '0741700003','Jl. Merdeka No. 10, Jambi'),
  ('PMS-04','PT Farmindo Sumatera',     '0741700004','Jl. Jend. Sudirman No. 40, Jambi'),
  ('PMS-05','UD Alkes Barokah',         '0741700005','Jl. Prof. M. Yamin No. 6, Jambi');

-- ---------------------------------------------------------------------
-- 7b. DATA TRANSAKSI
-- Semua kunci tamu diisi lewat INSERT ... SELECT dengan KODE ALAMI
-- (no_rm, kode_dokter, kode_poli, kode_tindakan, kode_obat), bukan menebak id.
-- Tarif dan harga DISALIN dari master saat transaksi (AB-04).
-- ---------------------------------------------------------------------

-- Kunjungan: 20 baris pada 4 tanggal (12-15 Oktober 2026). KJ-2610-0007 =
-- contoh Lembar Kunjungan di p02. Waktu diisi eksplisit karena ini data
-- historis; pada sistem berjalan kolom ini terisi otomatis (AB-02).
INSERT INTO kunjungan (no_kunjungan, tanggal_jam_kunjungan, id_pasien,
                       id_dokter, id_poli, keluhan, diagnosis)
SELECT x.nomor, x.tgl, p.id_pasien, d.id_dokter, l.id_poli, x.keluhan, x.diag
FROM (
  SELECT 'KJ-2610-0001' AS nomor, '2026-10-12 08:05:00' AS tgl, 'RM-000124' AS rm, 'DR-01' AS dok, 'PL-UM' AS pol, 'Sakit kepala dan pusing' AS keluhan, 'Hipertensi ringan' AS diag
  UNION ALL SELECT 'KJ-2610-0002','2026-10-12 08:30:00','RM-000125','DR-02','PL-GG','Gigi berlubang dan nyeri','Karies gigi'
  UNION ALL SELECT 'KJ-2610-0003','2026-10-12 08:50:00','RM-000126','DR-03','PL-KA','Kontrol kehamilan 20 minggu','Kehamilan normal'
  UNION ALL SELECT 'KJ-2610-0004','2026-10-12 09:00:00','RM-000127','DR-05','PL-UM','Batuk dan pilek 5 hari','Infeksi saluran pernapasan akut'
  UNION ALL SELECT 'KJ-2610-0005','2026-10-12 09:05:00','RM-000128','DR-04','PL-KA','Demam dan batuk 2 hari','Faringitis akut'
  UNION ALL SELECT 'KJ-2610-0006','2026-10-12 09:10:00','RM-000129','DR-05','PL-LN','Nyeri sendi lutut','Osteoartritis'
  UNION ALL SELECT 'KJ-2610-0007','2026-10-12 09:15:00','RM-000123','DR-01','PL-UM','Demam 3 hari','Infeksi saluran pernapasan atas'
  UNION ALL SELECT 'KJ-2610-0008','2026-10-13 08:00:00','RM-000130','DR-01','PL-UM','Nyeri ulu hati','Dispepsia'
  UNION ALL SELECT 'KJ-2610-0009','2026-10-13 08:20:00','RM-000123','DR-01','PL-UM','Kontrol demam, batuk tersisa','Infeksi saluran pernapasan atas membaik'
  UNION ALL SELECT 'KJ-2610-0010','2026-10-13 08:45:00','RM-000125','DR-02','PL-GG','Gigi geraham sakit','Pulpitis'
  UNION ALL SELECT 'KJ-2610-0011','2026-10-13 09:10:00','RM-000124','DR-05','PL-UM','Pusing berulang','Hipertensi ringan'
  UNION ALL SELECT 'KJ-2610-0012','2026-10-13 09:40:00','RM-000128','DR-04','PL-KA','Jadwal imunisasi','Sehat, imunisasi lanjutan'
  UNION ALL SELECT 'KJ-2610-0013','2026-10-13 10:05:00','RM-000127','DR-05','PL-UM','Luka robek di tangan','Vulnus laceratum'
  UNION ALL SELECT 'KJ-2610-0014','2026-10-14 08:10:00','RM-000129','DR-05','PL-LN','Kontrol tekanan darah','Hipertensi'
  UNION ALL SELECT 'KJ-2610-0015','2026-10-14 08:40:00','RM-000126','DR-03','PL-KA','Mual di pagi hari','Kehamilan 21 minggu'
  UNION ALL SELECT 'KJ-2610-0016','2026-10-14 09:15:00','RM-000130','DR-01','PL-UM','Gatal dan ruam kulit','Dermatitis alergi'
  UNION ALL SELECT 'KJ-2610-0017','2026-10-14 10:00:00','RM-000125','DR-02','PL-GG','Kontrol setelah cabut gigi','Pascapencabutan, sembuh baik'
  UNION ALL SELECT 'KJ-2610-0018','2026-10-15 08:30:00','RM-000123','DR-05','PL-UM','Batuk berdahak','Bronkitis akut'
  UNION ALL SELECT 'KJ-2610-0019','2026-10-15 09:00:00','RM-000128','DR-04','PL-KA','Demam dan nafsu makan turun','Infeksi virus ringan'
  UNION ALL SELECT 'KJ-2610-0020','2026-10-15 09:30:00','RM-000130','DR-01','PL-GZ','Konsultasi berat badan','Gizi kurang ringan'
) x
JOIN pasien p ON p.no_rm = x.rm
JOIN dokter d ON d.kode_dokter = x.dok
JOIN poli   l ON l.kode_poli = x.pol;

-- Detail tindakan: 32 baris, paling banyak 4 baris per kunjungan (AB-03).
-- tarif_saat_tindakan disalin dari tarif terkini (AB-04).
INSERT INTO detail_tindakan (id_kunjungan, id_tindakan, tarif_saat_tindakan)
SELECT k.id_kunjungan, t.id_tindakan, t.tarif_tindakan
FROM (
  SELECT 'KJ-2610-0001' AS nomor, 'TD-01' AS kd
  UNION ALL SELECT 'KJ-2610-0001','TD-02'
  UNION ALL SELECT 'KJ-2610-0002','TD-03'
  UNION ALL SELECT 'KJ-2610-0003','TD-05'
  UNION ALL SELECT 'KJ-2610-0004','TD-01'
  UNION ALL SELECT 'KJ-2610-0005','TD-01'
  UNION ALL SELECT 'KJ-2610-0005','TD-02'
  UNION ALL SELECT 'KJ-2610-0006','TD-01'
  UNION ALL SELECT 'KJ-2610-0006','TD-02'
  UNION ALL SELECT 'KJ-2610-0007','TD-01'
  UNION ALL SELECT 'KJ-2610-0007','TD-02'
  UNION ALL SELECT 'KJ-2610-0008','TD-01'
  UNION ALL SELECT 'KJ-2610-0009','TD-02'
  UNION ALL SELECT 'KJ-2610-0010','TD-01'
  UNION ALL SELECT 'KJ-2610-0010','TD-02'
  UNION ALL SELECT 'KJ-2610-0010','TD-03'
  UNION ALL SELECT 'KJ-2610-0010','TD-04'
  UNION ALL SELECT 'KJ-2610-0011','TD-01'
  UNION ALL SELECT 'KJ-2610-0011','TD-02'
  UNION ALL SELECT 'KJ-2610-0012','TD-06'
  UNION ALL SELECT 'KJ-2610-0013','TD-07'
  UNION ALL SELECT 'KJ-2610-0013','TD-01'
  UNION ALL SELECT 'KJ-2610-0014','TD-02'
  UNION ALL SELECT 'KJ-2610-0015','TD-05'
  UNION ALL SELECT 'KJ-2610-0016','TD-01'
  UNION ALL SELECT 'KJ-2610-0017','TD-03'
  UNION ALL SELECT 'KJ-2610-0018','TD-01'
  UNION ALL SELECT 'KJ-2610-0018','TD-02'
  UNION ALL SELECT 'KJ-2610-0019','TD-01'
  UNION ALL SELECT 'KJ-2610-0019','TD-02'
  UNION ALL SELECT 'KJ-2610-0020','TD-01'
  UNION ALL SELECT 'KJ-2610-0020','TD-02'
) x
JOIN kunjungan k ON k.no_kunjungan = x.nomor
JOIN tindakan  t ON t.kode_tindakan = x.kd;

-- Resep: 16 baris (4 kunjungan tanpa resep: 0009, 0012, 0014, 0017).
-- Nomor resep mengikuti 4 digit akhir nomor kunjungan.
INSERT INTO resep (no_resep, id_kunjungan)
SELECT CONCAT('RSP-2610-', RIGHT(no_kunjungan, 4)), id_kunjungan
FROM kunjungan
WHERE RIGHT(no_kunjungan, 4) IN ('0001','0002','0003','0004','0005','0006','0007','0008',
                                 '0010','0011','0013','0015','0016','0018','0019','0020');

-- Detail resep: 30 baris, paling banyak 4 baris per resep (AB-03).
-- harga_satuan_resep disalin dari harga jual terkini (AB-04).
INSERT INTO detail_resep (id_resep, id_obat, qty_obat_resep, harga_satuan_resep, aturan_pakai)
SELECT r.id_resep, o.id_obat, x.qty, o.harga_jual_obat, x.aturan
FROM (
  SELECT 'RSP-2610-0001' AS nr, 'OB-001' AS ko, 6 AS qty, '3 x 1 bila nyeri' AS aturan
  UNION ALL SELECT 'RSP-2610-0002','OB-003', 6,'3 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0003','OB-007',30,'1 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0003','OB-006',30,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0004','OB-004',10,'1 x 1 malam hari'
  UNION ALL SELECT 'RSP-2610-0004','OB-001',10,'3 x 1 bila demam'
  UNION ALL SELECT 'RSP-2610-0005','OB-001',10,'3 x 1/2 bila demam'
  UNION ALL SELECT 'RSP-2610-0005','OB-006',10,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0006','OB-003',10,'2 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0006','OB-005',10,'2 x 1 sebelum makan'
  UNION ALL SELECT 'RSP-2610-0007','OB-001',10,'3 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0007','OB-002',15,'3 x 1 habiskan'
  UNION ALL SELECT 'RSP-2610-0008','OB-005',10,'3 x 1 sebelum makan'
  UNION ALL SELECT 'RSP-2610-0010','OB-002',15,'3 x 1 habiskan'
  UNION ALL SELECT 'RSP-2610-0010','OB-003',10,'3 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0011','OB-006',20,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0013','OB-002',15,'3 x 1 habiskan'
  UNION ALL SELECT 'RSP-2610-0013','OB-003',10,'3 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0013','OB-001',10,'3 x 1 bila nyeri'
  UNION ALL SELECT 'RSP-2610-0013','OB-006',10,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0015','OB-007',30,'1 x 1 sesudah makan'
  UNION ALL SELECT 'RSP-2610-0015','OB-006',30,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0016','OB-004', 7,'1 x 1 malam hari'
  UNION ALL SELECT 'RSP-2610-0018','OB-002',15,'3 x 1 habiskan'
  UNION ALL SELECT 'RSP-2610-0018','OB-001',10,'3 x 1 bila demam'
  UNION ALL SELECT 'RSP-2610-0018','OB-006',10,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0019','OB-001',10,'3 x 1/2 bila demam'
  UNION ALL SELECT 'RSP-2610-0019','OB-006',10,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0020','OB-006',30,'1 x 1 pagi hari'
  UNION ALL SELECT 'RSP-2610-0020','OB-007',30,'1 x 1 sesudah makan'
) x
JOIN resep r ON r.no_resep = x.nr
JOIN obat  o ON o.kode_obat = x.ko;

-- Pembayaran: satu per kunjungan (AB-07). jumlah_bayar = total tindakan +
-- total obat, dihitung dari baris detail. Kunjungan 0004, 0010, 0015 BELUM
-- LUNAS (jumlah_bayar 0) untuk bahan kueri KI-05.
INSERT INTO pembayaran (no_pembayaran, id_kunjungan, tanggal_bayar,
                        jumlah_bayar, metode_bayar, status_bayar)
SELECT CONCAT('BYR-2610-', RIGHT(k.no_kunjungan, 4)),
       k.id_kunjungan,
       k.tanggal_jam_kunjungan + INTERVAL 35 MINUTE,
       (SELECT COALESCE(SUM(dt.tarif_saat_tindakan), 0)
          FROM detail_tindakan dt WHERE dt.id_kunjungan = k.id_kunjungan)
     + (SELECT COALESCE(SUM(dr.qty_obat_resep * dr.harga_satuan_resep), 0)
          FROM resep rs JOIN detail_resep dr ON dr.id_resep = rs.id_resep
         WHERE rs.id_kunjungan = k.id_kunjungan),
       IF(MOD(k.id_kunjungan, 2) = 1, 'tunai', 'transfer'),
       'lunas'
FROM kunjungan k
WHERE RIGHT(k.no_kunjungan, 4) NOT IN ('0004','0010','0015');

INSERT INTO pembayaran (no_pembayaran, id_kunjungan, tanggal_bayar,
                        jumlah_bayar, metode_bayar, status_bayar)
SELECT CONCAT('BYR-2610-', RIGHT(k.no_kunjungan, 4)),
       k.id_kunjungan, k.tanggal_jam_kunjungan, 0, 'tunai', 'belum_lunas'
FROM kunjungan k
WHERE RIGHT(k.no_kunjungan, 4) IN ('0004','0010','0015');

-- Pembelian obat dari pemasok: 5 faktur, 10 baris detail (AB-11)
INSERT INTO pembelian_obat (no_faktur_pembelian, tanggal_pembelian, id_pemasok)
SELECT x.faktur, x.tgl, p.id_pemasok
FROM (
  SELECT 'FK-0085' AS faktur, '2026-09-28' AS tgl, 'PMS-03' AS kp
  UNION ALL SELECT 'FK-0087','2026-10-05','PMS-03'
  UNION ALL SELECT 'FK-0412','2026-10-06','PMS-01'
  UNION ALL SELECT 'FK-0091','2026-10-08','PMS-02'
  UNION ALL SELECT 'FK-0120','2026-10-10','PMS-04'
) x
JOIN pemasok p ON p.kode_pemasok = x.kp;

INSERT INTO detail_pembelian_obat (id_pembelian_obat, id_obat, qty_pembelian_obat, harga_beli_obat)
SELECT pb.id_pembelian_obat, o.id_obat, x.qty, x.harga
FROM (
  SELECT 'FK-0085' AS faktur, 'PMS-03' AS kp, 'OB-002' AS ko, 100 AS qty, 1400 AS harga
  UNION ALL SELECT 'FK-0085','PMS-03','OB-005',100, 500
  UNION ALL SELECT 'FK-0087','PMS-03','OB-001',100, 700
  UNION ALL SELECT 'FK-0087','PMS-03','OB-003',100,1000
  UNION ALL SELECT 'FK-0412','PMS-01','OB-007',100, 400
  UNION ALL SELECT 'FK-0412','PMS-01','OB-006',200, 450
  UNION ALL SELECT 'FK-0091','PMS-02','OB-001',150, 720
  UNION ALL SELECT 'FK-0091','PMS-02','OB-002',100,1450
  UNION ALL SELECT 'FK-0120','PMS-04','OB-003', 50,1000
  UNION ALL SELECT 'FK-0120','PMS-04','OB-005',100, 520
) x
JOIN pemasok p         ON p.kode_pemasok = x.kp
JOIN pembelian_obat pb ON pb.no_faktur_pembelian = x.faktur AND pb.id_pemasok = p.id_pemasok
JOIN obat o            ON o.kode_obat = x.ko;

-- Sesuaikan stok: dikurangi obat yang diserahkan (AB-05), ditambah obat
-- yang diterima dari pemasok (AB-11).
UPDATE obat o
SET o.stok_obat = o.stok_obat
      - COALESCE((SELECT SUM(dr.qty_obat_resep) FROM detail_resep dr WHERE dr.id_obat = o.id_obat), 0)
      + COALESCE((SELECT SUM(db.qty_pembelian_obat) FROM detail_pembelian_obat db WHERE db.id_obat = o.id_obat), 0)
WHERE o.id_obat > 0;

-- ---------------------------------------------------------------------
-- Verifikasi jumlah baris semua tabel
-- Harapan: pasien 8, dokter 5, poli 5, tindakan 7, obat 8, pemasok 5,
--          kunjungan 20, detail_tindakan 32, resep 16, detail_resep 30,
--          pembayaran 20, pembelian_obat 5, detail_pembelian_obat 10
-- ---------------------------------------------------------------------
SELECT 'pasien' AS tabel, COUNT(*) AS jumlah_baris FROM pasien
UNION ALL SELECT 'dokter',                COUNT(*) FROM dokter
UNION ALL SELECT 'poli',                  COUNT(*) FROM poli
UNION ALL SELECT 'tindakan',              COUNT(*) FROM tindakan
UNION ALL SELECT 'obat',                  COUNT(*) FROM obat
UNION ALL SELECT 'pemasok',               COUNT(*) FROM pemasok
UNION ALL SELECT 'kunjungan',             COUNT(*) FROM kunjungan
UNION ALL SELECT 'detail_tindakan',       COUNT(*) FROM detail_tindakan
UNION ALL SELECT 'resep',                 COUNT(*) FROM resep
UNION ALL SELECT 'detail_resep',          COUNT(*) FROM detail_resep
UNION ALL SELECT 'pembayaran',            COUNT(*) FROM pembayaran
UNION ALL SELECT 'pembelian_obat',        COUNT(*) FROM pembelian_obat
UNION ALL SELECT 'detail_pembelian_obat', COUNT(*) FROM detail_pembelian_obat;