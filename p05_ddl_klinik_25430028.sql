-- =====================================================================
-- p05_ddl_klinik_25430028.sql  |  Milestone Proyek 5: DDL Klinik IK Sehat
-- Basis data proyek: klinik_028 (NIM 25430028, tema klinik)
-- Parameter P = 2  ->  batas baris per transaksi P + 2 = 4 (AB-03)
-- Skrip dapat dijalankan ulang dari basis data kosong (DROP anak -> induk).
-- Kode AB-xx merujuk ke p02_kebutuhan_data_25430028.md.
-- =====================================================================
USE klinik_028;

-- ---------------------------------------------------------------------
-- 0. Hapus tabel lama: urutan ANAK -> INDUK
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS detail_pembelian_obat;
DROP TABLE IF EXISTS pembelian_obat;
DROP TABLE IF EXISTS pembayaran;
DROP TABLE IF EXISTS detail_resep;
DROP TABLE IF EXISTS resep;
DROP TABLE IF EXISTS detail_tindakan;
DROP TABLE IF EXISTS kunjungan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS obat;
DROP TABLE IF EXISTS tindakan;
DROP TABLE IF EXISTS poli;
DROP TABLE IF EXISTS dokter;
DROP TABLE IF EXISTS pasien;

-- ---------------------------------------------------------------------
-- 1. Tabel induk / master (tanpa kunci tamu)
-- ---------------------------------------------------------------------
CREATE TABLE pasien (
  id_pasien            INT          NOT NULL AUTO_INCREMENT,
  no_rm                CHAR(9)      NOT NULL,              -- RM-000123
  nik_pasien           CHAR(16)     NOT NULL,              -- data pribadi
  nama_pasien          VARCHAR(100) NOT NULL,
  tanggal_lahir_pasien DATE         NOT NULL,
  jenis_kelamin_pasien ENUM('L','P') NOT NULL,
  no_hp_pasien         VARCHAR(15)  NULL,                  -- data pribadi
  alamat_pasien        VARCHAR(200) NULL,                  -- data pribadi
  PRIMARY KEY (id_pasien),
  UNIQUE KEY uq_pasien_rm  (no_rm),                        -- AB-01
  UNIQUE KEY uq_pasien_nik (nik_pasien),                   -- AB-01
  CONSTRAINT ck_pasien_rm  CHECK (no_rm REGEXP '^RM-[0-9]{6}$'),      -- AB-01
  CONSTRAINT ck_pasien_nik CHECK (nik_pasien REGEXP '^[0-9]{16}$')    -- AB-01
) ENGINE=InnoDB;

CREATE TABLE dokter (
  id_dokter           SMALLINT     NOT NULL AUTO_INCREMENT,
  kode_dokter         VARCHAR(10)  NOT NULL,               -- DR-01
  no_str_dokter       VARCHAR(20)  NOT NULL,
  nama_dokter         VARCHAR(100) NOT NULL,
  spesialisasi_dokter VARCHAR(60)  NOT NULL,
  PRIMARY KEY (id_dokter),
  UNIQUE KEY uq_dokter_kode (kode_dokter),
  UNIQUE KEY uq_dokter_str  (no_str_dokter)
) ENGINE=InnoDB;

CREATE TABLE poli (
  id_poli   SMALLINT    NOT NULL AUTO_INCREMENT,
  kode_poli VARCHAR(10) NOT NULL,                          -- PL-UM
  nama_poli VARCHAR(60) NOT NULL,
  PRIMARY KEY (id_poli),
  UNIQUE KEY uq_poli_kode (kode_poli)
) ENGINE=InnoDB;

CREATE TABLE tindakan (
  id_tindakan    SMALLINT      NOT NULL AUTO_INCREMENT,
  kode_tindakan  VARCHAR(10)   NOT NULL,                   -- TD-01
  nama_tindakan  VARCHAR(100)  NOT NULL,
  tarif_tindakan DECIMAL(12,2) NOT NULL,                   -- tarif terkini
  PRIMARY KEY (id_tindakan),
  UNIQUE KEY uq_tindakan_kode (kode_tindakan),
  CONSTRAINT ck_tindakan_tarif CHECK (tarif_tindakan >= 0)
) ENGINE=InnoDB;

CREATE TABLE obat (
  id_obat                  INT           NOT NULL AUTO_INCREMENT,
  kode_obat                VARCHAR(10)   NOT NULL,         -- OB-015
  nama_obat                VARCHAR(100)  NOT NULL,
  harga_jual_obat          DECIMAL(12,2) NOT NULL,         -- harga terkini
  stok_obat                INT           NOT NULL DEFAULT 0,
  batas_minimum_stok_obat  INT           NOT NULL DEFAULT 0,
  tanggal_kedaluwarsa_obat DATE          NOT NULL,         -- AB-06
  PRIMARY KEY (id_obat),
  UNIQUE KEY uq_obat_kode (kode_obat),
  CONSTRAINT ck_obat_stok  CHECK (stok_obat >= 0),                 -- AB-05
  CONSTRAINT ck_obat_batas CHECK (batas_minimum_stok_obat >= 0),
  CONSTRAINT ck_obat_harga CHECK (harga_jual_obat >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      INT          NOT NULL AUTO_INCREMENT,
  kode_pemasok    VARCHAR(10)  NOT NULL,                   -- PMS-03
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15)  NOT NULL,
  alamat_pemasok  VARCHAR(200) NOT NULL,
  PRIMARY KEY (id_pemasok),
  UNIQUE KEY uq_pemasok_kode (kode_pemasok)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 2. Kunjungan dan turunannya
-- ---------------------------------------------------------------------
CREATE TABLE kunjungan (
  id_kunjungan          INT          NOT NULL AUTO_INCREMENT,
  no_kunjungan          CHAR(12)     NOT NULL,             -- KJ-2610-0007
  tanggal_jam_kunjungan DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,  -- AB-02 (otomatis)
  id_pasien             INT          NOT NULL,             -- AB-02
  id_dokter             SMALLINT     NOT NULL,             -- AB-02
  id_poli               SMALLINT     NOT NULL,             -- AB-02
  keluhan               VARCHAR(255) NULL,                 -- data kesehatan, AB-09; diisi dokter (PB-03)
  diagnosis             VARCHAR(255) NULL,                 -- data kesehatan, AB-09; diisi dokter (PB-03)
  PRIMARY KEY (id_kunjungan),
  UNIQUE KEY uq_kunjungan_no (no_kunjungan),
  CONSTRAINT fk_kunjungan_pasien FOREIGN KEY (id_pasien) REFERENCES pasien (id_pasien),  -- AB-10: RESTRICT
  CONSTRAINT fk_kunjungan_dokter FOREIGN KEY (id_dokter) REFERENCES dokter (id_dokter),
  CONSTRAINT fk_kunjungan_poli   FOREIGN KEY (id_poli)   REFERENCES poli (id_poli)
) ENGINE=InnoDB;

CREATE TABLE detail_tindakan (
  id_kunjungan        INT           NOT NULL,
  id_tindakan         SMALLINT      NOT NULL,
  tarif_saat_tindakan DECIMAL(12,2) NOT NULL,              -- AB-04: tarif saat transaksi
  PRIMARY KEY (id_kunjungan, id_tindakan),
  CONSTRAINT fk_dtindakan_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan),  -- AB-10
  CONSTRAINT fk_dtindakan_tindakan  FOREIGN KEY (id_tindakan)  REFERENCES tindakan (id_tindakan),
  CONSTRAINT ck_dtindakan_tarif CHECK (tarif_saat_tindakan >= 0)
) ENGINE=InnoDB;

CREATE TABLE resep (
  id_resep     INT         NOT NULL AUTO_INCREMENT,
  no_resep     VARCHAR(15) NOT NULL,                       -- RSP-2609-0031
  id_kunjungan INT         NOT NULL,
  PRIMARY KEY (id_resep),
  UNIQUE KEY uq_resep_no (no_resep),
  UNIQUE KEY uq_resep_kunjungan (id_kunjungan),            -- ERD: kunjungan 1 -- 0..1 resep
  CONSTRAINT fk_resep_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan)  -- AB-10
) ENGINE=InnoDB;

CREATE TABLE detail_resep (
  id_resep            INT           NOT NULL,
  id_obat             INT           NOT NULL,
  qty_obat_resep      SMALLINT      NOT NULL,
  harga_satuan_resep  DECIMAL(12,2) NOT NULL,              -- AB-04: harga saat resep
  aturan_pakai        VARCHAR(100)  NOT NULL,
  PRIMARY KEY (id_resep, id_obat),
  CONSTRAINT fk_dresep_resep FOREIGN KEY (id_resep) REFERENCES resep (id_resep),  -- AB-10
  CONSTRAINT fk_dresep_obat  FOREIGN KEY (id_obat)  REFERENCES obat (id_obat),
  CONSTRAINT ck_dresep_qty   CHECK (qty_obat_resep > 0),            -- satu baris
  CONSTRAINT ck_dresep_harga CHECK (harga_satuan_resep >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembayaran (
  id_pembayaran  INT           NOT NULL AUTO_INCREMENT,
  no_pembayaran  VARCHAR(15)   NOT NULL,                   -- BYR-2609-0018
  id_kunjungan   INT           NOT NULL,
  tanggal_bayar  DATETIME      NOT NULL DEFAULT CURRENT_TIMESTAMP,   -- otomatis
  jumlah_bayar   DECIMAL(12,2) NOT NULL DEFAULT 0,
  metode_bayar   ENUM('tunai','transfer') NOT NULL,
  status_bayar   ENUM('belum_lunas','lunas') NOT NULL DEFAULT 'belum_lunas',
  PRIMARY KEY (id_pembayaran),
  UNIQUE KEY uq_pembayaran_no (no_pembayaran),
  UNIQUE KEY uq_pembayaran_kunjungan (id_kunjungan),       -- AB-07: satu pembayaran per kunjungan
  CONSTRAINT fk_pembayaran_kunjungan FOREIGN KEY (id_kunjungan) REFERENCES kunjungan (id_kunjungan),  -- AB-10
  CONSTRAINT ck_pembayaran_jumlah CHECK (jumlah_bayar >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 3. Pembelian obat dari pemasok
-- ---------------------------------------------------------------------
CREATE TABLE pembelian_obat (
  id_pembelian_obat   INT         NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20) NOT NULL,                -- dari pemasok
  tanggal_pembelian   DATE        NOT NULL,
  id_pemasok          INT         NOT NULL,
  PRIMARY KEY (id_pembelian_obat),
  UNIQUE KEY uq_pembelian_faktur (id_pemasok, no_faktur_pembelian),   -- kamus data: unik per pemasok
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok) REFERENCES pemasok (id_pemasok)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian_obat (
  id_pembelian_obat INT           NOT NULL,
  id_obat           INT           NOT NULL,
  qty_pembelian_obat INT          NOT NULL,                -- AB-11
  harga_beli_obat   DECIMAL(12,2) NOT NULL,                -- AB-11: harga saat faktur
  PRIMARY KEY (id_pembelian_obat, id_obat),
  CONSTRAINT fk_dbeliobat_pembelian FOREIGN KEY (id_pembelian_obat) REFERENCES pembelian_obat (id_pembelian_obat) ON DELETE CASCADE,
  CONSTRAINT fk_dbeliobat_obat      FOREIGN KEY (id_obat)           REFERENCES obat (id_obat),
  CONSTRAINT ck_dbeliobat_qty   CHECK (qty_pembelian_obat > 0),     -- AB-11
  CONSTRAINT ck_dbeliobat_harga CHECK (harga_beli_obat >= 0)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- 4. Aturan yang BELUM dapat dijaga oleh constraint (ditandai untuk Modul 14)
-- ---------------------------------------------------------------------
-- AB-03  Maksimal 4 baris tindakan per kunjungan dan 4 baris obat per resep
--        (P + 2 = 4): menyangkut JUMLAH BARIS per transaksi, tidak bisa dijaga
--        CHECK -> Modul 14 (transaksi / trigger).
-- AB-05  Obat tidak diserahkan bila qty melebihi stok: melibatkan dua tabel
--        (detail_resep dan obat) -> Modul 14. Yang dijaga di sini hanya
--        stok_obat >= 0.
-- AB-06  Obat kedaluwarsa tidak boleh diserahkan: membandingkan dengan tanggal
--        saat transaksi -> Modul 14.
-- AB-07  jumlah_bayar = total tagihan + denda: nilai turunan dari banyak baris
--        -> Modul 14. Struktur yang dijaga: satu pembayaran per kunjungan.
-- AB-08  Denda Rp2.000 per hari setelah hari ke-7: nilai TURUNAN, dihitung
--        saat kueri (tidak disimpan sebagai kolom).
-- AB-09  Pembatasan akses keluhan dan diagnosis: diatur lewat hak akses
--        pengguna (bukan struktur tabel) pada modul keamanan.
-- AB-10  Data kunjungan dan pembayaran tidak dihapus: seluruh kunci tamu pada
--        jalur kunjungan memakai ON DELETE RESTRICT (bawaan).
-- Tanggal lahir dan tanggal pembelian tidak boleh di masa depan: memerlukan
--        fungsi tanggal sekarang -> divalidasi di Modul 14.

-- ---------------------------------------------------------------------
-- 5. Verifikasi
-- ---------------------------------------------------------------------
SHOW TABLES;
SHOW CREATE TABLE kunjungan;
