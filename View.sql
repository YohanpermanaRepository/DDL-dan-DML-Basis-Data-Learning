CREATE DATABASE peminjaman_buku;

use peminjaman_buku;

create table buku (
	Kode_Buku VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    Judul_Buku VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Pengarang_Buku VARCHAR(300) NOT NULL DEFAULT 'data_kosong',
    Penerbit_Buku VARCHAR(300) NOT NULL DEFAULT 'data_kosong',
    Tahun_Buku VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    Jumlah_Buku VARCHAR(50) NOT NULL DEFAULT 'data_kosong',
    Status_Buku VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    Klasifikasi_Buku VARCHAR(200) NOT NULL DEFAULT 'data_kosong',
    
    PRIMARY KEY (Kode_Buku)
);

create table petugas (
	IdPetugas VARCHAR(200) NOT NULL DEFAULT 'data_kosong',
    Username VARCHAR(200) NOT NULL DEFAULT 'data_kosong',
    `Password` VARCHAR(100) NOT NULL,
    Nama VARCHAR(250) NOT NULL DEFAULT 'Userandom',
    
    PRIMARY KEY (IdPetugas)
);

create table anggota (
    IdAnggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Nama_Anggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Angkatan_Anggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Tempat_Lahir_Anggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Tanggal_Lahir_Anggota DATE,
    No_Telp INT NOT NULL,
    Jenis_Kelamin VARCHAR(100) NOT NULL DEFAULT 'Hidden',
    Status_Pinjam VARCHAR(150) NOT NULL DEFAULT 'Aktif',
    
    PRIMARY KEY (IdAnggota)
);

ALTER TABLE anggota MODIFY COLUMN No_Telp VARCHAR(100);

create table pengembalian (
	Kode_Kembali VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    IdAnggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    Kode_Buku VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    IdPetugas VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    Tgl_Pinjam DATE,
    Tgl_Kembali DATE,
    Denda VARCHAR(150) NOT NULL DEFAULT 'Dilarang meminjam buku lebih dari 1 bulan',
    
    PRIMARY KEY(Kode_Kembali)
);

create table peminjaman (
	Kode_Peminjaman VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    IdAnggota VARCHAR(250) NOT NULL DEFAULT 'data_kosong',
    IdPetugas VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    Tanggal_Pinjam DATE,
    Tanggal_Kembali DATE,
    Kode_Buku VARCHAR(100) NOT NULL DEFAULT 'data_kosong',
    
    PRIMARY KEY(Kode_Peminjaman)
);

ALTER TABLE peminjaman 
	ADD CONSTRAINT FK_AnggotaPinjam 
    FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota) 
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE peminjaman 
	ADD CONSTRAINT FK_PetugasPeminjaman 
    FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas) 
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE peminjaman 
	ADD CONSTRAINT FK_BukuDipinjam 
    FOREIGN KEY (Kode_Buku) REFERENCES buku(Kode_Buku) 
    ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE pengembalian 
	ADD CONSTRAINT FK_AnggotaKembali 
    FOREIGN KEY (IdAnggota) REFERENCES anggota(IdAnggota) 
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE pengembalian 
	ADD CONSTRAINT FK_BukuDikembalikan 
    FOREIGN KEY (Kode_Buku) REFERENCES buku(Kode_Buku) 
    ON UPDATE CASCADE ON DELETE CASCADE;
    
ALTER TABLE pengembalian 
	ADD CONSTRAINT FK_PetugasPengembalian 
    FOREIGN KEY (IdPetugas) REFERENCES petugas(IdPetugas) 
    ON UPDATE CASCADE ON DELETE CASCADE;


INSERT INTO buku (Kode_Buku, Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku) VALUES 
('BOOK001', 'The Alchemist', 'Paulo Coelho', 'HarperCollins', 1988, 10, 'Tersedia', 'Fiction'),
('BOOK002', 'Animal Farm', 	'George Orwell', 'Secker and Warburg', 1945, 15, 'Tersedia', 'Political Fiction'),
('BOOK003', 'The Catcher in the Rye', 'J.D. Salinger', 'Little, Brown and Company', 1951, 10, 'Tersedia', 'Coming of Age'),
('BOOK004', 'The Great Gatsby', 'F. Scott Fitzgerald', 'Charles Scribner''s Sons', 1925, 10, 'Tersedia', 'Historical Fiction'),
('BOOK005', 'Pride and Prejudice', 'Jane Austen', 'T. Egerton', 1813, 15, 'Tersedia', 'Romance'),
('BOOK006', '1984', 'George Orwell', 'Secker and Warburg', 1949, 20, 'Tersedia', 'Dystopian Fiction'),
('BOOK007', 'One Hundred Years of Solitude', 'Gabriel Garcia Marquez', 'Harper & Row', 1967, 16, 'Tersedia', 'Magic Realism'),
('BOOK008', 'The Adventures of Huckleberry Finn', 'Mark Twain', 'Chatto & Windus', 1884, 14, 'Tersedia', 'Classic'),
('BOOK009', 'Jane Eyre', 'Charlotte Bronte', 'Smith, Elder & Co.', 1847, 2, 'Tersedia', 'Gothic Fiction'),
('BOOK010', 'The Picture of Dorian Gray', 'Oscar Wilde', 'Ward, Lock and Company', 1890, 20, 'Tersedia', 'Gothic Fiction');
select * from buku;

INSERT INTO anggota (IdAnggota, Nama_Anggota, Angkatan_Anggota, Tempat_Lahir_Anggota, Tanggal_Lahir_Anggota, No_Telp, Jenis_Kelamin, Status_Pinjam) VALUES 
('AGT001', 'Rizki', 2019, 'Jakarta', '2001-06-01', '08123456789', 'L', 'Aktif'),
('AGT002', 'Amanda', 2020, 'Bogor', '2002-02-14', '08567891234', 'P', 'Aktif'),
('AGT003', 'Agung', 2021, 'Yogyakarta', '2003-09-19', '08765432100', 'L', 'Aktif'),
('AGT004', 'Bella', 2019, 'Surabaya', '2001-08-09', '08234567891', 'P', 'Aktif'),
('AGT005', 'Dito', 2020, 'Bekasi', '2002-05-03', '08123456789', 'L', 'Aktif'),
('AGT006', 'Eka', 2021, 'Bandung', '2003-11-27', '08234567891', 'P', 'Aktif'),
('AGT007', 'Faisal', 2019, 'Jakarta', '2001-12-31', '08345678912', 'L', 'Aktif'),
('AGT008', 'Gita', 2020, 'Bogor', '2002-10-25', '08567891234', 'P', 'Aktif'),
('AGT009', 'Hadi', 2021, 'Yogyakarta', '2003-07-18', '08765432100', 'L', 'Aktif'),
('AGT010', 'Ira', 2019, 'Surabaya', '2001-04-12', '08123456789', 'P', 'Aktif');
SELECT * FROM anggota;

INSERT INTO petugas (IdPetugas, Username, `Password`, Nama) VALUES
('PT01', 'Yohan Permana', 'bismilah123', 'Han'),
('PT02', 'Adi Baskara', 'passwordku123', 'ADI'),
('PT03', 'Nathan Dirgantara', 'letmein', 'Dirga'),
('PT04', 'joe kanselo', 'abc123', 'Joe'),
('PT05', 'Michael Oryazabal', 'qwerty', 'Mich');
SELECT * FROM petugas;

INSERT INTO peminjaman (Kode_Peminjaman, IdAnggota, IdPetugas, Tanggal_Pinjam, Tanggal_Kembali, Kode_Buku) VALUES
('P001', 'AGT010', 'PT01', '2023-04-17', '2023-05-21', 'BOOK001'),
('P002', 'AGT002', 'PT03', '2023-04-12', '2023-05-15', 'BOOK003'),
('P003', 'AGT003', 'PT02', '2023-04-03', '2023-05-05', 'BOOK005'),
('P004', 'AGT004', 'PT04', '2023-04-07', '2023-05-10', 'BOOK007'),
('P005', 'AGT010', 'PT01', '2023-04-20', '2023-05-22', 'BOOK009'),
('P006', 'AGT010', 'PT05', '2023-04-14', '2023-05-16', 'BOOK001'),
('P007', 'AGT006', 'PT01', '2023-04-29', '2023-05-30', 'BOOK001'),
('P008', 'AGT010', 'PT03', '2023-04-10', '2023-05-14', 'BOOK003'),
('P009', 'AGT010', 'PT02', '2023-04-01', '2023-05-05', 'BOOK004'),
('P010', 'AGT010', 'PT04', '2023-04-18', '2023-05-21', 'BOOK006'),
('P011', 'AGT007', 'PT05', '2023-04-05', '2023-05-07', 'BOOK002'),
('P012', 'AGT005', 'PT03', '2023-04-20', '2023-05-24', 'BOOK010'),
('P013', 'AGT010', 'PT01', '2023-04-25', '2023-05-27', 'BOOK008'),
('P014', 'AGT008', 'PT05', '2023-04-15', '2023-05-19', 'BOOK006'),
('P015', 'AGT009', 'PT04', '2023-04-09', '2023-05-12', 'BOOK004'),
('P016', 'AGT001', 'PT02', '2023-04-01', '2023-05-05', 'BOOK002');
SELECT * FROM peminjaman;

INSERT INTO pengembalian (Kode_Kembali, IdAnggota, Kode_Buku, IdPetugas, Tgl_Pinjam, Tgl_Kembali, Denda) VALUES
('R001', 'AGT001', 'BOOK001','PT01', '2023-04-01', '2023-05-05', 'Tidak Kena Denda'),
('R002', 'AGT003', 'BOOK005', 'PT04', '2023-04-03', '2023-05-05', 'Tidak Kena Denda'),
('R003', 'AGT006', 'BOOK001', 'PT02', '2023-04-29', '2023-06-30', 'Terkena Denda Rp.20000'),
('R004', 'AGT002', 'BOOK003', 'PT03', '2023-04-12', '2023-05-15', 'Tidak Terdenda'),
('R005', 'AGT004', 'BOOK007', 'PT01', '2023-04-07', '2023-06-10', 'Terkena Denda Rp.20000');

SELECT * FROM pengembalian;

CREATE OR REPLACE VIEW viewsoal1 AS
SELECT x.Nama_Anggota, COUNT(y.Kode_Buku) AS `jumlah_buku_dipinjam`
FROM anggota x
JOIN peminjaman y ON x.IdAnggota = y.IdAnggota
GROUP BY x.IdAnggota
HAVING COUNT(y.Kode_Buku) > 5;

SELECT * FROM viewsoal1;


CREATE OR REPLACE VIEW viewsoal2 AS
SELECT x.IdPetugas, COUNT(x.Kode_Buku) AS `jumlah_buku_yangterpinjam`
FROM peminjaman x
GROUP BY x.IdPetugas;

SELECT * FROM viewsoal2;


CREATE OR REPLACE VIEW viewsoal3 AS
SELECT x.IdPetugas, COUNT(x.Kode_Buku) AS `jumlah_buku_yangterpinjam`
FROM peminjaman x
GROUP BY x.IdPetugas
HAVING COUNT(Kode_Buku) = 
	(SELECT MAX(`jumlah_buku_yangterpinjam`) 
		FROM (SELECT IdPetugas, COUNT(Kode_Buku) AS `jumlah_buku_yangterpinjam` 
        FROM peminjaman GROUP BY IdPetugas) AS `petugas_jumlah_buku`);
        
SELECT * FROM viewsoal3;


CREATE VIEW viewsoal4 AS
SELECT x.Judul_Buku, COUNT(y.Kode_Buku) AS `jumlah_pinjam`
FROM buku x
JOIN peminjaman y ON x.Kode_Buku = y.Kode_Buku
GROUP BY x.Judul_Buku
HAVING COUNT(y.Kode_Buku) = 
	(SELECT MAX(`jumlah_pinjam`) 
		FROM (SELECT COUNT(Kode_Buku) AS `jumlah_pinjam` 
        FROM peminjaman GROUP BY Kode_Buku) AS `jumlahbukupinjam`);
        
SELECT * FROM viewsoal4;
