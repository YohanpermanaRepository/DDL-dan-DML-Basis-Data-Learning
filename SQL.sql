CREATE DATABASE coba;
USE coba;

CREATE TABLE mahasiswa (
	keterangan VARCHAR(15)
);

ALTER TABLE mahasiswa ADD COLUMN nim INT(11) FIRST;
ALTER TABLE mahasiswa ADD COLUMN alamat VARCHAR(15);
ALTER TABLE mahasiswa ADD COLUMN phone VARCHAR(15) AFTER alamat;


ALTER TABLE mahasiswa MODIFY COLUMN nim CHAR(11);
ALTER TABLE mahasiswa CHANGE COLUMN phone telepon VARCHAR(20);

ALTER TABLE mahasiswa DROP COLUMN keterangan;

RENAME TABLE mahasiswa TO student;

ALTER TABLE student add primary key(nim);

desc student;


