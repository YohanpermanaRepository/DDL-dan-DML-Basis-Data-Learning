use peminjamanbuku2;

# Nomor 1
DROP PROCEDURE IF EXISTS tampilkan_profil_anggota;
DELIMITER //
CREATE PROCEDURE tampilkan_profil_anggota(IN Nama_atau_ID VARCHAR(200))
BEGIN
    SELECT 
        `IdAnggota` AS 'ID Anggota', 
        `Nama_Anggota` AS 'Nama Anggota', 
        `Tempat_Lahir_Anggota` AS 'Tempat Lahir', 
        `Tanggal_Lahir_Anggota` AS 'Tanggal Lahir', 
        `No_Telp` AS 'No. Telp', 
        CASE `Jenis_Kelamin`
            WHEN 'L' THEN 'Laki-laki'
            WHEN 'P' THEN 'Perempuan'
            ELSE 'Tidak diketahui'
        END AS 'Jenis Kelamin',
        'Membaca dan menulis' AS 'Hobi',
        YEAR(CURDATE()) - YEAR(`Tanggal_Lahir_Anggota`) AS 'Usia Sekarang'
    FROM `anggota` 
    WHERE `IdAnggota` = Nama_atau_ID OR `Nama_Anggota` = Nama_atau_ID;
END //
DELIMITER ;

CALL tampilkan_profil_anggota('AGT001');
CALL tampilkan_profil_anggota('Rizki');


# Nomor 2
DROP PROCEDURE IF EXISTS keterangan_pengingat_pengembalian;
DELIMITER //
CREATE PROCEDURE keterangan_pengingat_pengembalian (IN Nama_Atau_IdPeminjam VARCHAR(200))
BEGIN
    SELECT 
        `Nama_Anggota` AS 'Nama Anggota',
        `Judul_Buku` AS 'Buku',
        CONCAT (DATEDIFF(CURDATE(), `Tanggal_Pinjam`), ' Hari') AS 'Lama Pinjam',
        CASE 
            WHEN DATEDIFF(CURDATE(), `Tanggal_Pinjam`) <= 2 THEN "Silahkan Pergunakan Buku dengan baik" 
            WHEN DATEDIFF(CURDATE(), `Tanggal_Pinjam`) BETWEEN 3 AND 5 THEN "Ingat!, Waktu Pinjam segera habis"
            WHEN DATEDIFF(CURDATE(), `Tanggal_Pinjam`) >= 6 THEN "Warning!!!, Denda Menanti Anda"
        END AS 'Keterangan'
    FROM anggota JOIN peminjaman USING (IdAnggota) JOIN buku USING(Kode_Buku) 
    WHERE Nama_Anggota = Nama_Atau_IdPeminjam OR IdAnggota = Nama_Atau_IdPeminjam;
END //
DELIMITER ;

CALL keterangan_pengingat_pengembalian('AGT001');
CALL keterangan_pengingat_pengembalian('Rizki');


# Nomor 3
DROP PROCEDURE IF EXISTS cek_denda;
DELIMITER //
CREATE PROCEDURE cek_denda(IN IdAnggotaInput VARCHAR(250))
BEGIN
    DECLARE total_denda INT;
    
    -- Hitung total denda yang dimiliki oleh mahasiswa
    SELECT SUM(Denda) INTO total_denda FROM pengembalian WHERE IdAnggota = IdAnggotaInput;
    
    -- Jika total denda lebih besar dari 0, tampilkan data denda yang belum dibayarkan
    IF total_denda > 0 THEN
        SELECT Kode_Kembali, Tgl_Kembali, Denda FROM pengembalian WHERE IdAnggota = IdAnggotaInput AND Denda > 0;
    -- Jika total denda sama dengan 0, tampilkan pesan bahwa mahasiswa tidak memiliki tanggungan atau denda
    ELSEIF total_denda = 0 THEN
        SELECT CONCAT('Mahasiswa dengan IdAnggota ', IdAnggotaInput, ' tidak memiliki tanggungan atau denda.') AS 'Status';
    END IF;
END //
DELIMITER ;
CALL cek_denda('AGT006');


#Nomor 4
DROP PROCEDURE IF EXISTS checkingpeminjaman;
DELIMITER //
CREATE PROCEDURE checkingpeminjaman (IN batas INT)
BEGIN
	DECLARE i INT DEFAULT 1;
	DECLARE a VARCHAR(200) DEFAULT "00";
    DECLARE fill TEXT;
    SET @sql = '';
    
    WHILE i <= batas DO 
		SET a = CONCAT(a, ', ', "00" + i);
		SET i = i + 1 ;
    END WHILE;
    
    SET @sql = CONCAT('SELECT * FROM peminjaman WHERE Kode_Peminjaman IN (', a, ')');
	PREPARE fill FROM @sql;
    EXECUTE fill;
    DEALLOCATE PREPARE fill;
END //
DELIMITER ;
CALL checkingpeminjaman (10);


# Nomor 5

INSERT INTO `anggota` (`IdAnggota`, `Nama_Anggota`, `Angkatan_Anggota`, `Tempat_Lahir_Anggota`, `Tanggal_Lahir_Anggota`, `No_Telp`, `Jenis_Kelamin`, `Status_Pinjam`) VALUES
('AGT011', 'Ronney', '2025', 'Jombang', '2005-04-16', '085812818212', 'L', 'nonaktif');

DROP PROCEDURE IF EXISTS hpsagttidakaktif;
DELIMITER //
CREATE PROCEDURE hpsagttidakaktif()
BEGIN
	DELETE FROM anggota WHERE Jenis_Kelamin = 'L' AND Status_Pinjam = "nonaktif";
END //
DELIMITER ;

CALL hpsagttidakaktif ();	
SELECT * FROM anggota;
SET @@SESSION.sql_safe_updates = 0;


















