create database modul1_swalayan;
use modul1_swalayan; 

create table pelanggan(
id_pelanggan int (11) NOT null,
nama_pelanggan varchar (50) NOT null,
alamat_pelanggan varchar (50) NOT null,
no_telepon varchar (15) NOT null,
primary key (id_pelanggan)
);

INSERT INTO pelanggan (id_pelanggan, nama_pelanggan, alamat_pelanggan, no_telepon)
VALUES
(1, 'Yohan Soeharja', 'Jl. Ahmad Yani No. 123', 081234567890),
(2, 'Yongki Setiawan', 'Jl. Gatot Subroto No. 456', 082345678901),
(3, 'Sanjaya permana', 'Jl. Sudirman No. 789', 083456789012),
(4, 'Adi lesta yohan', 'Jl. Diponegoro No. 234', 084567890123),
(5, 'David gadgedin', 'Jl. Pahlawan No. 567', 085678901234),
(6, 'Dila amelia', 'Jl. Merdeka No. 890', 086789012345),
(7, 'Ginta', 'Jl. Imam Bonjol No. 123', 087890123456),
(8, 'Yura mimbininggar', 'Jl. Pemuda No. 456', 088901234567),
(9, 'Catleya', 'Jl. Asia Afrika No. 789', 089012345678),
(10, 'Radista', 'Jl. Veteran No. 234', 090123456789);


create table stok_barang(
id_barang int (11) not null,
nama_barang varchar (50) not null,
jumlah_stok_barang int (11),
harga_barang int (11) NOT null,
primary key (id_barang)
);

INSERT INTO stok_barang (id_barang, nama_barang, jumlah_stok_barang, harga_barang)
VALUES
(1, 'Buku Tulis', 100, 5000),
(2, 'Pulpen', 200, 2000),
(3, 'Pensil', 150, 1000),
(4, 'Bolpoin', 120, 3000),
(5, 'Kertas HVS', 50, 10000),
(6, 'Spidol', 80, 5000),
(7, 'Stabilo', 90, 7000),
(8, 'Penghapus', 100, 1500),
(9, 'Gunting', 70, 5000),
(10, 'Tipe-X', 120, 2000);


create table penjualan(
id_transaksi int (11) not null,
id_barang int (11) not null,
id_pelanggan int (11) not null,
jumlah_beli int (11) not null,
total_uang int (11) not null,
primary key (id_transaksi),
foreign key (id_barang) references stok_barang (id_barang) ,
foreign key (id_pelanggan) references pelanggan (id_pelanggan) 
);

INSERT INTO penjualan (id_transaksi, id_barang, id_pelanggan, jumlah_beli, total_uang)
VALUES
(1, 1, 1, 10, 50000),
(2, 2, 3, 20, 40000),
(3, 3, 2, 15, 15000),
(4, 4, 5, 12, 36000),
(5, 5, 4, 5, 50000),
(6, 6, 7, 8, 40000),
(7, 7, 9, 9, 63000),
(8, 8, 10, 10, 15000),
(9, 9, 8, 7, 35000),
(10, 10, 6, 12, 24000);


create table retur_barang(
id_retur int (11) NOT null,
nama_barang varchar (30) not null,
jumlah_barang int (11) NOT null,
kondisi varchar (225) not null,
id_barang int (11) not null,
primary key (id_retur),
foreign key (id_barang) references stok_barang (id_barang) 
);

INSERT INTO retur_barang (id_retur, nama_barang, jumlah_barang, kondisi, id_barang) VALUES
(1, 'Buku Tulis', 5, 'rusak', 1),
(2, 'Pulpen', 2, 'rusak', 2),
(3, 'Pensil', 3, 'tidak sesuai', 3),
(4, 'Bolpoin', 1, 'rusak', 4),
(5, 'Kertas HVS', 10, 'tidak sesuai', 5),
(6, 'Spidol', 0, 'rusak', 6),
(7, 'Stabilo', 1, 'tidak sesuai', 7),
(8, 'Penghapus', 2, 'rusak', 8),
(9, 'Gunting', 0, 'rusak', 9),
(10, 'Tipe-X', 3, 'tidak sesuai', 10);


create table supplier (
id_supplier int (11) not null,
nama_supplier varchar (225) not null,
alamat varchar (225) not null,
no_telepon varchar (15) not null,
primary key (id_supplier)
);

INSERT INTO supplier (id_supplier, nama_supplier, alamat, no_telepon) VALUES
(1, 'PT. Amanah Jaya', 'Jl. Merdeka No. 10', '081234567890'),
(2, 'CV. Sejahtera Baru', 'Jl. Sudirman No. 25', '082345678901'),
(3, 'UD. Maju Jaya', 'Jl. Raya Bogor Km. 25', '083456789012'),
(4, 'PT. Makmur Sentosa', 'Jl. Gatot Subroto No. 50', '084567890123'),
(5, 'CV. Indah Jaya Abadi', 'Jl. Pahlawan No. 15', '085678901234'),
(6, 'UD. Jaya Sentosa', 'Jl. Ahmad Yani No. 30', '086789012345'),
(7, 'PT. Barokah Sukses', 'Jl. Diponegoro No. 20', '087890123456'),
(8, 'CV. Cahaya Abadi', 'Jl. Gajah Mada No. 40', '088901234567'),
(9, 'UD. Maju Lancar', 'Jl. Veteran No. 35', '089012345678'),
(10, 'PT. Sejahtera Mandiri', 'Jl. Hayam Wuruk No. 12', '090123456789');

create table hutang_supplier (
id_hutang int (11) not null,
id_supplier int (11) not null,
id_barang int (11) not null,
stok_supply int (11) not null,
jumlah_hutang int (11) not null,
primary key (id_hutang),
foreign key (id_supplier) references supplier (id_supplier),
foreign key (id_barang) references stok_barang (id_barang)
);

INSERT INTO hutang_supplier (id_hutang, id_supplier, id_barang, stok_supply, jumlah_hutang) VALUES
(1, 3, 2, 100, 20000000),
(2, 4, 1, 50, 10000000),
(3, 2, 4, 200, 50000000),
(4, 1, 3, 150, 30000000),
(5, 5, 5, 75, 15000000),
(6, 3, 1, 25, 5000000),
(7, 2, 3, 100, 20000000),
(8, 4, 5, 50, 10000000),
(9, 1, 2, 200, 50000000),
(10, 5, 4, 150, 30000000);

create table membayar_hutang(
id_hutang int (11) not null,
id_supplier int (11) not null,
id_barang int (11) not null,
pembayaran_hutang int (11) not null,
foreign key (id_hutang) references hutang_supplier (id_hutang),
foreign key (id_supplier) references supplier (id_supplier),
foreign key (id_barang) references stok_barang (id_barang)
);

INSERT INTO membayar_hutang (id_hutang, id_supplier, id_barang, pembayaran_hutang) VALUES
(1, 3, 2, 5000000),
(2, 4, 1, 2500000),
(3, 2, 4, 10000000),
(4, 1, 3, 7500000),
(5, 5, 5, 5000000),
(6, 3, 1, 1500000),
(7, 2, 3, 3000000),
(8, 4, 5, 2000000),
(9, 1, 2, 5000000),
(10, 5, 4, 3500000);


select*from pelanggan;
select*from stok_barang;
select*from penjualan;
select*from retur_barang;
select*from supplier;
select*from hutang_supplier;
select*from membayar_hutang;



#RENAME TABLE pelanggan TO customer;

#ALTER TABLE customer RENAME TO pelanggan;

#drop database modul1_swalayan;
