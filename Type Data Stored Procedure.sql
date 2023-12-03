USE peminjaman_buku;

# 1. a Buatkanlah procedure dan lihatkan hasilnya untuk mengetahui umur buku kalau di lihat dari tahun penerbitan buku.

DELIMITER //
CREATE PROCEDURE `usia_buku`(IN jenis_pencarian VARCHAR(50), isi_pencarian VARCHAR(50) )
BEGIN
	IF jenis_pencarian = "years" THEN
        SELECT Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku, CONCAT(YEAR(CURDATE()) - isi_pencarian , " Tahun") AS Usia
        FROM buku 
        WHERE Tahun_Buku = isi_pencarian;
            
	ELSEIF jenis_pencarian = "name" THEN 
		SELECT Judul_Buku, Pengarang_Buku, Penerbit_Buku, Tahun_Buku, Jumlah_Buku, Status_Buku, Klasifikasi_Buku, CONCAT(YEAR(CURDATE()) - Tahun_Buku, " Tahun") AS Usia
        FROM buku
        WHERE Judul_Buku = isi_pencarian;
            
	ELSE 
		SELECT "input parameter dengan benar" AS ALERT ;
    END IF;
END //
DELIMITER ;
CALL `usia_buku`('name', 'The Alchemist');
CALL `usia_buku`('years', '1945');



# 1.b ATAU atau buatkanlah procedure untuk menghitung sudah berapa lama atau hari salah anggota tersebut meminjam buku jika diambilkan dari awal tanggal pinjam.
#Jika tanggal pengembalian kosong, hitung selisih antara tanggal sekarang dengan tanggal peminjaman menggunakan DATEDIFF. 
#Jika tidak kosong, hitung selisih antara tanggal pengembalian dan tanggal peminjaman.
 
DROP PROCEDURE IF EXISTS `agt_pinjam`;
DELIMITER //
CREATE PROCEDURE `agt_pinjam`(IN nama_anggota VARCHAR(50))
BEGIN
	SELECT 
		a.Nama_Anggota AS Nama, 
		IFNULL(b.Judul_Buku, "Belum Pinjam") AS Buku,
		CONCAT(IFNULL(DATEDIFF(
			CASE WHEN p.Tanggal_Kembali IS NULL THEN CURDATE() ELSE p.Tanggal_Kembali END, 
			p.Tanggal_Pinjam)
		, "Belum Pinjam"), " Hari") AS `Lama Pinjam`
	FROM 
		anggota a 
		LEFT JOIN peminjaman p ON a.IdAnggota = p.IdAnggota
		LEFT JOIN buku b ON b.Kode_Buku = p.Kode_Buku 
	WHERE 
		a.Nama_Anggota = nama_anggota;
END //

DELIMITER ;
CALL `agt_pinjam`("Ira");



# 2. Buatkan procedure untuk mendelete daftar buku yang tahun pembuatannya di bawah tahun 2000, tetapi jika penerbitnya dari AndhiPublisher maka tidak dapat di delete.

DROP PROCEDURE IF EXISTS `delete_buku`;
DELIMITER //
CREATE PROCEDURE `delete_buku`(OUT result VARCHAR(255))
BEGIN
	-- Mendeklarasikan variabel 'count' dengan tipe data INT
	DECLARE count INT;
    
    -- Menghapus buku yang memiliki tahun kurang dari 2000 dan penerbit bukan 'AndhiPublisher'
    DELETE FROM `buku`
    WHERE `Tahun_Buku` < 2000 AND `Penerbit_Buku` != 'HarperCollins';
	
    -- mengisi variabel 'count' dengan jumlah baris yang terpengaruh dari perintah DELETE diatas
    SET count = ROW_COUNT();
	
    -- apabila 'count' yang terpengaruh lebih dari 0, maka akan menampilkan berapa data yang dihapus, 
    -- apabila sama dengan 0 maka menampilkan pesan bahwa tidak ada data yang dihapus
    IF count > 0 THEN
		SET result = CONCAT(count, ' data buku berhasil dihapus.');
	ELSE
		SET result = 'Tidak ada data buku yang dihapus.';
	END IF;
END //
DELIMITER ;

CALL `delete_buku`(@result);
SELECT @result AS "keterangan";



# 3. Buatkanlah procedure untuk membuat perubahan data pada tabel buku, jika ada transaksi peminjaman pada tabel peminjaman berdasarkan kode buku tertentu maka
# jumlah buku berkurang. Sedangkan jika ada pengembalian buku pada tabel
# pengembalian buku dengan kode buku tertentu maka jumlah buku pada tabel buku
# akan bertambah.

DELIMITER //
CREATE PROCEDURE `update_jumlah_buku`(IN kode_buku VARCHAR(100), IN transaksi_type VARCHAR(50), IN transaksi_date DATE)
BEGIN
     DECLARE jumlah INT;
     DECLARE jumlah_peminjaman INT;
     DECLARE jumlah_pengembalian INT;
     SET jumlah_peminjaman = 0;
     SET jumlah_pengembalian = 0;

     -- Hitung jumlah peminjaman dan pengembalian buku
     SELECT COUNT(`peminjaman`.`Kode_Peminjaman`) INTO jumlah_peminjaman
     FROM `buku`
     JOIN `peminjaman` USING(Kode_Buku)
     WHERE `buku`.`Kode_Buku` = kode_buku AND `peminjaman`.`Tanggal_Pinjam` <= transaksi_date
     GROUP BY `buku`.`Kode_Buku`;

     SELECT COUNT(`pengembalian`.`Kode_Kembali`) INTO jumlah_pengembalian
     FROM `buku`
     JOIN `pengembalian` USING(Kode_Buku)
     WHERE `buku`.`Kode_Buku` = kode_buku AND `pengembalian`.`Tgl_Kembali` <= transaksi_date
     GROUP BY `buku`.`Kode_Buku`;

     -- Perbarui jumlah buku berdasarkan jenis transaksi
     IF transaksi_type = 'peminjaman' THEN
         SET jumlah = -jumlah_peminjaman;
     ELSEIF transaksi_type = 'pengembalian' THEN
         SET jumlah = jumlah_pengembalian;
     ELSE
         SET jumlah = 0;
     END IF;

     UPDATE `buku` SET `Jumlah_Buku` = `Jumlah_Buku` + jumlah WHERE `Kode_Buku` = kode_buku;

     -- Munculkan tabel buku dengan kode buku yang diminta
     SELECT * FROM `buku` WHERE `Kode_Buku` = kode_buku;
END //
DELIMITER ;

CALL `update_jumlah_buku`('BOOK001', 'pengembalian', '2024-05-30');
CALL `update_jumlah_buku`('BOOK001', 'peminjaman', '2023-04-29');



#4. buatkanlah procedure untuk mengetahui berapa jumlah buku yang dipinjam anggota tertentu jika ada transaksi pengembalian atau peminjaman buku pada tabel peminjaman, tabel buku dan tabel pengembalian.

DROP PROCEDURE IF EXISTS `hitung_pinjaman_buku`;
DELIMITER //
CREATE PROCEDURE `hitung_pinjaman_buku` (IN id_anggota VARCHAR(10))
BEGIN
	DECLARE total_pinjam INT DEFAULT 0;
	DECLARE total_kembali INT DEFAULT 0;

	-- Menghitung jumlah buku yang dipinjam oleh anggota pada tabel peminjaman
	SELECT COUNT(DISTINCT peminjaman.Kode_Peminjaman) INTO total_pinjam FROM `anggota` JOIN `peminjaman` USING (`IdAnggota`) WHERE `anggota`.`IdAnggota` = id_anggota;

	-- Menghitung jumlah buku yang dikembalikan oleh anggota pada tabel pengembalian
	SELECT COUNT(DISTINCT pengembalian.Kode_Kembali) INTO total_kembali FROM `anggota` JOIN `pengembalian` USING (`IdAnggota`) WHERE `anggota`.`IdAnggota` = id_anggota;

	-- Mengembalikan jumlah buku yang sedang dipinjam oleh anggota
	SELECT 
		`anggota`.`Nama_Anggota`,
		total_pinjam AS `Total_Pinjam`,
		total_kembali AS `Total_Kembali`,
		(total_pinjam - total_kembali) AS `Buku_Yang_Belum_Dikembalikan`
	FROM `anggota` WHERE `anggota`.`IdAnggota` = id_anggota;
END //
DELIMITER ;
CALL `hitung_pinjaman_buku`('AGT010');



#Buatkanlah procedure untuk menghapus procedure yang sudah dibuat.

DROP PROCEDURE `usia_buku`; #hapus 1.a
DROP PROCEDURE `agt_pinjam`; #hapus 1.b
DROP PROCEDURE `delete_buku`;#hapus 2
DROP PROCEDURE `update_jumlah_buku`; #hapus 3
DROP PROCEDURE `hapus_pinjaman_buku`; #hapus 4



DELIMITER //
CREATE PROCEDURE hapusProsedur(IN namaProsedur VARCHAR(55))
BEGIN
	DELETE FROM mysql.proc WHERE db = 'peminjaman_buku' AND TYPE = 'PROCEDURE' AND NAME = namaProsedur;
END//

DELIMITER ;


CALL hapusProsedur('update_jumlah_buku');







