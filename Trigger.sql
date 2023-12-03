CREATE DATABASE carentalmodul7;
use carentalmodul7;
create table mobil(
	ID_MOBIL INT(11),
	PLATNO VARCHAR(100),
    MERK VARCHAR(100),
    JENIS VARCHAR(100),
    HARGA_SEWA_PERHARI INT(20),
    PRIMARY KEY (ID_MOBIL)
);

create table peminjaman(
	ID INT(11),
	ID_MOBIL INT(11),
    ID_PELANGGAN INT(11),
    TGL_PINJAM DATE,
    TGL_RENCANA_KEMBALI DATE,
    TOTAL_HARI INT(20),
    TOTAL_BAYAR INT(20),
    TGL_KEMBALI DATE,
    DENDA INT(20),
    PRIMARY KEY (ID)
);

create table pelanggan(
	ID_PELANGGAN INT(11),
	NAMA VARCHAR(100),
    ALAMAT VARCHAR(100),
    NIK VARCHAR(16),
    NO_TELEPON VARCHAR(20),
    JENIS_KELAMIN VARCHAR(20),
    PRIMARY KEY (ID_PELANGGAN)
);

INSERT INTO mobil (ID_MOBIL, PLATNO, MERK, JENIS, HARGA_SEWA_PERHARI) 
VALUES 
  (1, 'B 1234 ABC', 'Toyota Avanza', 'Minibus', 250000),
  (2, 'B 5678 DEF', 'Honda Jazz', 'Hatchback', 200000),
  (3, 'B 9101 GHI', 'Mitsubishi Pajero', 'SUV', 400000),
  (4, 'B 2345 JKL', 'Nissan X-Trail', 'SUV', 350000),
  (5, 'B 6789 MNO', 'Daihatsu Xenia', 'Minibus', 230000),
  (6, 'B 0123 PQR', 'Suzuki Ertiga', 'Minibus', 240000),
  (7, 'B 4567 STU', 'Toyota Fortuner', 'SUV', 380000),
  (8, 'B 8910 VWX', 'Honda CR-V', 'SUV', 370000),
  (9, 'B 2345 YZA', 'Mitsubishi Mirage', 'Sedan', 180000),
  (10, 'B 6789 BCD', 'Nissan Grand Livina', 'Minibus', 220000);




INSERT INTO pelanggan (ID_PELANGGAN, NAMA, ALAMAT, NIK, NO_TELEPON, JENIS_KELAMIN) 
VALUES 
  (1001, 'Yohan permana', 'Jl. manggis No. 123', '1234567890123456', '081234567890', 'Laki-laki'),
  (1002, 'Jane Smith', 'Jl. nanas No. 456', '9876543210987654', '087654321098', 'Perempuan'),
  (1003, 'Michael Johnson', 'Jl. semangka No. 789', '5678901234567890', '089012345678', 'Laki-laki'),
  (1004, 'Emily Davis', 'Jl. rambutan No. 1011', '0123456789012345', '081234567890', 'Perempuan'),
  (1005, 'David Anderson', 'Jl. durian No. 1213', '7890123456789012', '087654321098', 'Laki-laki');


INSERT INTO peminjaman (ID, ID_MOBIL, ID_PELANGGAN, TGL_PINJAM, TGL_RENCANA_KEMBALI, TOTAL_HARI, TOTAL_BAYAR, TGL_KEMBALI, DENDA) 
VALUES 
  ('1','1','1001','2023-05-17','2023-05-19', 2,'800000','2023-05-19','0'),
  ('2','2','1002','2023-05-17','2023-05-19', 4,'800000','2023-05-20','10000');








#soal1 Pastikan tgl_rencana_kembali tidak lebih awal dari tgl_pinjam
DROP TRIGGER IF EXISTS `periksa_tgl_rencana_kembali`;
DELIMITER //
CREATE TRIGGER periksa_tgl_rencana_kembali
BEFORE INSERT ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.TGL_RENCANA_KEMBALI < NEW.TGL_PINJAM THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tanggal Tidak boleh lebih awal dari tanggal pinjam!!!!';
    END IF;
END//
DELIMITER ;

DROP procedure IF EXISTS tambah_peminjaman;
DELIMITER //
CREATE PROCEDURE tambah_peminjaman(
	IN pinj_id INT,
    IN pinj_id_mobil INT,
    IN pinj_id_pelanggan INT,
    IN pinj_tgl_pinjam DATE,
    IN pinj_tgl_rencana_kembali DATE,
    IN pinj_total_hari INT,
    IN pinj_total_bayar INT,
    IN pinj_tgl_kembali DATE,
    IN pinj_denda INT
)
BEGIN
    IF pinj_tgl_rencana_kembali < pinj_tgl_pinjam THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tanggal Tidak boleh lebih awal dari tanggal pinjam!!!!';
    ELSE
        INSERT INTO peminjaman (
            ID,
            ID_MOBIL,
            ID_PELANGGAN,
            TGL_PINJAM,
            TGL_RENCANA_KEMBALI,
            TOTAL_HARI,
            TOTAL_BAYAR,
            TGL_KEMBALI,
            DENDA
        ) VALUES (
			pinj_id,
            pinj_id_mobil,
            pinj_id_pelanggan,
            pinj_tgl_pinjam,
            pinj_tgl_rencana_kembali,
            pinj_total_hari,
            pinj_total_bayar,
            pinj_tgl_kembali,
            pinj_denda
        );
    END IF;
END//
DELIMITER ;
CALL tambah_peminjaman('3','3','1003','2023-05-18','2023-05-19','2','800000','2023-05-19','0');



#2.	Ketika mobil dikembalikan, tgl_kembali di isi, juga menghitung total_bayar dan denda (jika ada)
DROP TRIGGER IF EXISTS `tgl_kembali_mobil`;
DELIMITER $$
CREATE TRIGGER tgl_kembali_mobil
AFTER UPDATE ON peminjaman
FOR EACH ROW
BEGIN
    IF NEW.TGL_KEMBALI IS NOT NULL THEN
        UPDATE peminjaman SET TGL_KEMBALI = CURRENT_DATE() WHERE ID = NEW.ID;
    END IF;
END$$
DELIMITER ;


DROP procedure IF EXISTS menghitung_denda;
DELIMITER $$
CREATE PROCEDURE menghitung_denda (IN p_id INT)
BEGIN
    DECLARE v_total_hari INT;
    DECLARE p_total_bayar INT;
    DECLARE v_harga_sewa INT;
    DECLARE v_tgl date;
    DECLARE v_denda INT;
    
    SELECT TGL_RENCANA_KEMBALI, TOTAL_HARI, HARGA_SEWA_PERHARI INTO v_tgl, v_total_hari, v_harga_sewa
    FROM peminjaman
    JOIN mobil ON peminjaman.ID_MOBIL = mobil.ID_MOBIL
    WHERE peminjaman.ID = p_id;

    SET p_total_bayar = v_total_hari * v_harga_sewa;
    SET v_denda = DATEDIFF(CURRENT_DATE(), v_tgl) * v_harga_sewa;
    UPDATE peminjaman SET TOTAL_BAYAR = p_total_bayar, DENDA = v_denda WHERE ID = p_id;
END$$
DELIMITER ;

CALL menghitung_denda(1);


#3 Ketika insert data ke tabel pelanggan, pastikan panjang NIK sesuai dengan aturan yang berlaku
DROP TRIGGER IF EXISTS `pengecekanNIK_pelanggan`;
DELIMITER //
CREATE TRIGGER pengecekanNIK_pelanggan BEFORE INSERT ON pelanggan
FOR EACH ROW
BEGIN
    DECLARE NIK_length INT;
    SET NIK_length = CHAR_LENGTH(NEW.NIK);
    
    IF NIK_length <> 16 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'NIK harus 16 karakter';
    END IF;
END //
DELIMITER ;

DROP procedure IF EXISTS isi_pelanggan;
DELIMITER //
CREATE PROCEDURE isi_pelanggan(
    IN p_ID VARCHAR(100),
    IN p_NAMA VARCHAR(100),
    IN p_ALAMAT VARCHAR(100),
    IN p_NIK VARCHAR(16),
    IN p_NO_TELEPON VARCHAR(20),
    IN p_JENIS_KELAMIN VARCHAR(20)
)
BEGIN
    DECLARE NIK_length INT;
    SET NIK_length = CHAR_LENGTH(p_NIK);
    
    IF NIK_length <> 16 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Panjang NIK harus 16 karakter.';
    ELSE
        INSERT INTO pelanggan (ID_PELANGGAN, NAMA, ALAMAT, NIK, NO_TELEPON, JENIS_KELAMIN)
        VALUES (p_ID, p_NAMA, p_ALAMAT, p_NIK, p_NO_TELEPON, p_JENIS_KELAMIN);
    END IF;
END //
DELIMITER ;
CALL isi_pelanggan('1006', 'DHIKA', 'Jl. NIAS No. 123', '1234567890123456', '081234567890', 'Laki-laki');



#4 Ketika insert data ke tabel mobil, pastikan di kolom platno, 1/2 karakter awal harus huruf
DROP TRIGGER IF EXISTS `validasiplat`;
DELIMITER //
CREATE TRIGGER validasiplat BEFORE INSERT ON mobil
FOR EACH ROW
BEGIN
    DECLARE first_two_chars VARCHAR(2);
    DECLARE first_two_chars_check INT;
    SET first_two_chars = SUBSTRING(NEW.PLATNO, 1, 2);
    SET first_two_chars_check = 0;
    IF (first_two_chars REGEXP '^[A-Za-z]+$') THEN
        SET first_two_chars_check = 1;
    END IF;
    IF (first_two_chars_check = 0) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The first two characters of PLATNO must be alphabetic.';
    END IF;
END//
DELIMITER ;

DELIMITER //
CREATE PROCEDURE tambah_mobil(
    IN mobil_id INT,
    IN platno VARCHAR(100),
    IN merk VARCHAR(100),
    IN jenis VARCHAR(100),
    IN harga_sewa_perhari INT
)
BEGIN
    INSERT INTO mobil (ID_MOBIL, PLATNO, MERK, JENIS, HARGA_SEWA_PERHARI)
    VALUES (mobil_id, platno, merk, jenis, harga_sewa_perhari);
END//
DELIMITER ;

CALL tambah_mobil(11, 'Ae123', 'Crv', 'Sedan', 100000);

