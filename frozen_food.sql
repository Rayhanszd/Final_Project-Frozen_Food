-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 19, 2024 at 02:26 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `frozen_food`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `p_username` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_role` VARCHAR(50))   BEGIN
    INSERT INTO user (username, password, role)
    VALUES (p_username, p_password, p_role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `GetStokProduk` (IN `produk_id` INT)   BEGIN
    SELECT stok FROM produk WHERE id = produk_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HapusTransaksi` (IN `id_transaksi` INT)   BEGIN
    DELETE FROM transaksi_masuk WHERE id = id_transaksi;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `hapus_produk` (IN `p_id` INT)   BEGIN
    -- Hapus data dari tabel transaksi terkait
    DELETE FROM transaksi_masuk WHERE produk_id = p_id;
    DELETE FROM transaksi_keluar WHERE produk_id = p_id;

    -- Hapus data dari tabel produk
    DELETE FROM produk WHERE id = p_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `LihatRiwayatTransaksi` (IN `produk_id` INT)   BEGIN
    IF produk_id IS NULL THEN
        SELECT tm.id AS id_transaksi, p.nama AS nama_produk, tm.jumlah AS jumlah_masuk, tm.tanggal_masuk
        FROM transaksi_masuk tm
        JOIN produk p ON tm.produk_id = p.id;
    ELSE
        SELECT tm.id AS id_transaksi, p.nama AS nama_produk, tm.jumlah AS jumlah_masuk, tm.tanggal_masuk
        FROM transaksi_masuk tm
        JOIN produk p ON tm.produk_id = p.id
        WHERE tm.produk_id = produk_id;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lihat_produk` ()   BEGIN
    SELECT id, nama, stok, harga
    FROM produk
    ORDER BY nama;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lihat_produk_Ke2` ()   BEGIN
    SELECT id, nama, stok, harga
    FROM produk
    ORDER BY nama
    LIMIT 10;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TambahStokProduk` (IN `produk_id` INT, IN `jumlah` INT)   BEGIN
    DECLARE stok_sekarang INT;
    -- Ambil stok saat ini
    SELECT stok INTO stok_sekarang FROM produk WHERE id = produk_id;
    
    -- Update stok produk
    UPDATE produk SET stok = stok_sekarang + jumlah WHERE id = produk_id;
    
    -- Insert transaksi barang masuk
    INSERT INTO transaksi_masuk (produk_id, jumlah) VALUES (produk_id, jumlah);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_produk` (IN `p_nama` VARCHAR(100), IN `p_stok` INT, IN `p_harga` DECIMAL(10,2))   BEGIN
    INSERT INTO produk (nama, stok, harga) 
    VALUES (p_nama, p_stok, p_harga);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `tambah_transaksi_keluar` (IN `p_produk_id` INT, IN `p_jumlah` INT)   BEGIN
    -- Tambahkan data transaksi keluar
    INSERT INTO transaksi_keluar (produk_id, jumlah, tanggal)
    VALUES (p_produk_id, p_jumlah, CURRENT_TIMESTAMP);

    -- Update stok di tabel produk
    UPDATE produk
    SET stok = stok - p_jumlah
    WHERE id = p_produk_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_produk` (IN `p_id` INT, IN `p_nama` VARCHAR(100), IN `p_stok` INT, IN `p_harga` DECIMAL(10,2))   BEGIN
    UPDATE produk
    SET nama = p_nama, stok = p_stok, harga = p_harga
    WHERE id = p_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `barangterlaris`
-- (See below for the actual view)
--
CREATE TABLE `barangterlaris` (
`nama_produk` varchar(255)
,`total_terjual` decimal(32,0)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `penjualantertinggi`
-- (See below for the actual view)
--
CREATE TABLE `penjualantertinggi` (
`bulan` varchar(7)
,`total_penjualan` decimal(32,2)
);

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `harga` varchar(255) DEFAULT NULL,
  `harga_beli` int(11) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `supplier` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`id`, `nama`, `stok`, `harga`, `harga_beli`, `foto`, `supplier`) VALUES
(153, 'Cumi Flower Indomina', 4, '15000', 10000, 'IMG_20240615_183839.jpg', 'Murtiasih Frozen Food'),
(157, 'Sosis Ayam Merah Salam 750G', 7, '35000', 29000, 'IMG_20240615_183918.jpg', 'Murtiasih Frozen Food'),
(180, 'Scalop FirstGrade', 7, '10000', 5000, 'IMG-20240305-WA0086.jpg', 'Murtiasih Frozen Food'),
(193, 'Beef Cocktail Sausage Kanzler', 10, '41500', 37500, 'IMG_20240615_184100.jpg', 'Murtiasih Frozen Food'),
(199, 'Cireng Nikmat Rasa Isi 105', 14, '12500', 6500, 'IMG-20240305-WA0077.jpg', 'Murtiasih Frozen Food'),
(208, 'Bakso Sapi Vitalia', 16, '11000', 7000, 'IMG-20240305-WA0082.jpg', 'Murtiasih Frozen Food'),
(227, 'Ikan Olahan ILM 500G', 21, '15000', 11000, 'IMG_20240615_183824.jpg', 'Murtiasih Frozen Food'),
(245, 'Naget Ayam Asimo 450G', 11, '17000', 11000, 'IMG_20240615_184049.jpg', 'Murtiasih Frozen Food'),
(253, 'Chicken Nugget Vitalia', 14, '13000', 9000, 'IMG_20240615_184040.jpg', 'Murtiasih Frozen Food'),
(270, 'Burger Sapi Vitalia 280G', 21, '15000', 9000, 'IMG-20240305-WA0089.jpg', 'Murtiasih Frozen Food'),
(305, 'Chicken Nugget Akumo 500G', 8, '14000', 10000, 'IMG_20240615_184024.jpg', 'Murtiasih Frozen Food'),
(380, 'Sosis Sapi Umia-mi Extra 2Pcs', 25, '26000', 22000, 'IMG-20240305-WA0088.jpg', 'Murtiasih Frozen Food'),
(384, 'Chicken Sausage Champ IsI 3', 47, '14000', 10000, 'IMG-20240305-WA0098.jpg', 'Murtiasih Frozen Food'),
(390, 'Burger Bernadi Isi 20 Biji', 12, '34000', 29000, 'IMG_20240615_183805.jpg', 'Murtiasih Frozen Food'),
(399, 'Sosis Bakar Muantap', 8, '14000', 9000, 'IMG-20240305-WA0096.jpg', 'Murtiasih Frozen Food'),
(405, 'Cireng Telor Nikmat Rasa', 8, '14000', 8000, 'IMG-20240305-WA0078.jpg', 'Murtiasih Frozen Food'),
(411, 'Sosis Daging Kamil 80G', 26, '12000', 7000, 'IMG-20240305-WA0083.jpg', 'Murtiasih Frozen Food'),
(434, 'Udang Gulung JS Isi 22', 5, '14000', 9000, 'IMG-20240305-WA0091.jpg', 'Murtiasih Frozen Food'),
(444, 'Bakso Ikan FirstGrade 500G', 8, '14000', 9000, 'IMG-20240305-WA0087.jpg', 'Murtiasih Frozen Food'),
(449, 'Sosis Bakar Salam Isi 12', 10, '21000', 17000, 'IMG-20240305-WA0102.jpg', 'Murtiasih Frozen Food'),
(451, 'Chicken Karaage Goldstar 500G', 10, '25000', 21000, 'IMG_20240615_184159.jpg', 'Murtiasih Frozen Food'),
(465, 'Cireng Merah Rani Food', 10, '9000', 4000, 'IMG-20240305-WA0079.jpg', 'Murtiasih Frozen Food'),
(495, 'Mariyam Pandan', 15, '15000', 10000, 'IMG-20240305-WA0085.jpg', 'Murtiasih Frozen Food'),
(520, 'Mariyam Original', 15, '12000', 7000, 'IMG-20240305-WA0093.jpg', 'Murtiasih Frozen Food'),
(528, 'Sosis Bakar Salam', 10, '17000', 12000, 'IMG_20240615_183910.jpg', 'Murtiasih Frozen Food'),
(534, 'Sosis Sapi Yona Isi 7', 15, '22000', 18000, 'IMG_20240615_184019.jpg', 'Murtiasih Frozen Food'),
(537, 'Bakso Aci Gendhis', 25, '8000', 3000, 'IMG-20240615-WA0027.jpg', 'Murtiasih Frozen Food'),
(546, 'Bakso Ayam Salam 500G', 20, '17000', 11000, 'IMG_20240615_183833.jpg', 'Murtiasih Frozen Food'),
(557, 'Mini Pao umia-mi Isi 30', 10, '25000', 20000, 'IMG_20240615_184142.jpg', 'Murtiasih Frozen Food'),
(572, 'Beef Sausage Champ Isi 6', 25, '17000', 12000, 'IMG-20240305-WA0099.jpg', 'Murtiasih Frozen Food'),
(601, 'Bakso Sapi Kamil', 14, '17000', 11000, 'IMG-20240305-WA0117.jpg', 'Murtiasih Frozen Food'),
(609, 'Crispy Chicken Nugget GoldStar', 10, '21000', 16000, 'IMG-20240305-WA0113.jpg', 'Murtiasih Frozen Food'),
(617, 'French Fries Fiesta', 25, '23000', 17000, 'IMG-20240305-WA0110.jpg', 'Murtiasih Frozen Food'),
(633, 'Nugget Coin Uenaaak', 15, '23000', 17000, 'IMG_20240615_184109.jpg', 'Murtiasih Frozen Food'),
(673, 'Naget Ayam S Asimo', 9, '16000', 11000, 'IMG-20240305-WA0080.jpg', 'Murtiasih Frozen Food'),
(726, 'French Fries 808', 15, '21000', 16000, 'IMG-20240305-WA0101.jpg', 'Murtiasih Frozen Food'),
(764, 'Scallop Umia-mi Isi 45', 9, '9000', 5000, 'IMG_20240615_184035.jpg', 'Murtiasih Frozen Food'),
(786, 'Naget Ayam Salam 1000G', 15, '36000', 31000, 'IMG_20240615_184123.jpg', 'Murtiasih Frozen Food'),
(805, 'Sosis Bakar SoNice Isi 10', 14, '26500', 20500, 'IMG_20240615_183851.jpg', 'Murtiasih Frozen Food'),
(850, 'Mariyam Coklat', 9, '12000', 8000, 'IMG-20240305-WA0094.jpg', 'Murtiasih Frozen Food'),
(868, 'Naget Ayam Ngetop 500G', 14, '14000', 9000, 'IMG_20240615_184006.jpg', 'Murtiasih Frozen Food'),
(899, 'Fish Dumpling Chicken Cedea', 20, '18000', 12000, 'IMG_20240615_183816.jpg', 'Murtiasih Frozen Food'),
(944, 'Ikan Olahan Bintang ILM 500G', 10, '17000', 13000, 'IMG-20240305-WA0092.jpg', 'Murtiasih Frozen Food'),
(949, 'Chicken Nugget Bartoz 500G', 10, '17500', 11500, 'IMG_20240615_184013.jpg', 'Murtiasih Frozen Food'),
(991, 'Sosis Ayam Champ', 10, '26500', 21500, 'IMG-20240305-WA0097.jpg', 'Murtiasih Frozen Food'),
(995, 'Sosis Merah Ngetop 500G', 5, '18000', 14000, 'IMG-20240305-WA0118.jpg', 'Murtiasih Frozen Food');

-- --------------------------------------------------------

--
-- Stand-in structure for view `produk_view`
-- (See below for the actual view)
--
CREATE TABLE `produk_view` (
`id` int(11)
,`nama` varchar(255)
,`harga` varchar(255)
,`stok` int(11)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `stok_produk_view`
-- (See below for the actual view)
--
CREATE TABLE `stok_produk_view` (
`nama_produk` varchar(255)
,`stok` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_detail`
--

CREATE TABLE `transaction_detail` (
  `detail_id` int(11) NOT NULL,
  `transaction_id` int(11) NOT NULL,
  `nama_produk` varchar(255) NOT NULL,
  `harga` decimal(10,2) NOT NULL,
  `jumlah_terjual` int(11) NOT NULL,
  `total_harga` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_detail`
--

INSERT INTO `transaction_detail` (`detail_id`, `transaction_id`, `nama_produk`, `harga`, `jumlah_terjual`, `total_harga`) VALUES
(4, 6, 'Naget Ayam Asimo 450G', 17000.00, 1, 17000.00),
(5, 6, 'Bakso Sapi Kamil', 17000.00, 1, 17000.00),
(6, 6, 'Mariyam Coklat', 12000.00, 1, 12000.00),
(7, 7, 'Ikan Olahan ILM 500G', 15000.00, 1, 15000.00),
(8, 7, 'Cireng Nikmat Rasa Isi 105', 12500.00, 1, 12500.00),
(9, 7, 'Burger Sapi Vitalia 280G', 15000.00, 1, 15000.00),
(10, 7, 'Sosis Bakar SoNice Isi 10', 26500.00, 1, 26500.00),
(11, 8, 'Burger Sapi Vitalia 280G', 15000.00, 1, 15000.00),
(12, 8, 'Naget Ayam Asimo 450G', 17000.00, 2, 34000.00),
(13, 8, 'Naget Ayam S Asimo', 16000.00, 1, 16000.00);

-- --------------------------------------------------------

--
-- Table structure for table `transaction_header`
--

CREATE TABLE `transaction_header` (
  `transaction_id` int(11) NOT NULL,
  `total_items` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `transaction_date` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaction_header`
--

INSERT INTO `transaction_header` (`transaction_id`, `total_items`, `total_amount`, `transaction_date`) VALUES
(1, 1, 43000.00, '2024-12-19 11:03:23'),
(2, 0, 0.00, '2024-12-19 11:04:40'),
(3, 0, 0.00, '2024-12-19 11:05:10'),
(4, 1, 14000.00, '2024-12-19 11:05:18'),
(5, 1, 14000.00, '2024-12-19 11:06:55'),
(6, 3, 46000.00, '2024-12-19 11:59:18'),
(7, 4, 69000.00, '2024-12-19 12:00:50'),
(8, 4, 65000.00, '2024-12-19 14:03:35');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi`
--

CREATE TABLE `transaksi` (
  `id` int(11) NOT NULL,
  `nama_produk` varchar(255) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `jumlah_terjual` int(11) DEFAULT NULL,
  `total_harga` decimal(10,2) DEFAULT NULL,
  `tanggal` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi`
--

INSERT INTO `transaksi` (`id`, `nama_produk`, `harga`, `jumlah_terjual`, `total_harga`, `tanggal`) VALUES
(46, 'Naget Ayam Ngetop 500G', 14000.00, 1, 14000.00, '2024-12-19 17:06:55'),
(47, 'Naget Ayam Asimo 450G', 17000.00, 1, 17000.00, '2024-12-19 17:59:18'),
(48, 'Bakso Sapi Kamil', 17000.00, 1, 17000.00, '2024-12-19 17:59:18'),
(49, 'Mariyam Coklat', 12000.00, 1, 12000.00, '2024-12-19 17:59:18'),
(50, 'Ikan Olahan ILM 500G', 15000.00, 1, 15000.00, '2024-12-19 18:00:50'),
(51, 'Cireng Nikmat Rasa Isi 105', 12500.00, 1, 12500.00, '2024-12-19 18:00:50'),
(52, 'Burger Sapi Vitalia 280G', 15000.00, 1, 15000.00, '2024-12-19 18:00:51'),
(53, 'Sosis Bakar SoNice Isi 10', 26500.00, 1, 26500.00, '2024-12-19 18:00:51'),
(54, 'Burger Sapi Vitalia 280G', 15000.00, 1, 15000.00, '2024-12-19 20:03:35'),
(55, 'Naget Ayam Asimo 450G', 17000.00, 2, 34000.00, '2024-12-19 20:03:35'),
(56, 'Naget Ayam S Asimo', 16000.00, 1, 16000.00, '2024-12-19 20:03:35');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_keluar`
--

CREATE TABLE `transaksi_keluar` (
  `id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi_keluar`
--

INSERT INTO `transaksi_keluar` (`id`, `produk_id`, `jumlah`, `tanggal`) VALUES
(28, 153, 1, '2024-12-16 04:11:33'),
(29, 227, 2, '2024-12-16 04:11:37'),
(30, 157, 1, '2024-12-18 00:47:15'),
(37, 157, 1, '2024-12-18 05:17:50'),
(38, 153, 2, '2024-12-18 05:17:50'),
(39, 180, 3, '2024-12-18 05:17:50'),
(41, 153, 1, '2024-12-18 05:25:58'),
(43, 390, 2, '2024-12-18 05:31:22'),
(44, 390, 1, '2024-12-18 05:31:22'),
(46, 153, 1, '2024-12-18 05:34:19'),
(47, 384, 2, '2024-12-18 05:34:19'),
(48, 411, 1, '2024-12-18 05:34:19'),
(50, 444, 1, '2024-12-18 05:36:24'),
(51, 411, 2, '2024-12-18 05:36:24'),
(53, 405, 2, '2024-12-18 05:37:08'),
(55, 208, 1, '2024-12-18 07:08:54'),
(56, 384, 1, '2024-12-18 07:08:54'),
(57, 208, 2, '2024-12-18 07:10:52'),
(58, 227, 1, '2024-12-18 07:10:52'),
(59, 411, 1, '2024-12-18 07:10:52'),
(60, 245, 1, '2024-12-18 07:15:39'),
(61, 399, 1, '2024-12-18 07:15:39'),
(62, 253, 1, '2024-12-18 08:37:43'),
(63, 305, 1, '2024-12-18 08:37:43'),
(64, 208, 1, '2024-12-19 09:53:06'),
(65, 305, 1, '2024-12-19 09:53:06'),
(66, 764, 1, '2024-12-19 09:53:06'),
(67, 157, 1, '2024-12-19 09:54:49');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_masuk`
--

CREATE TABLE `transaksi_masuk` (
  `id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `jumlah` int(11) DEFAULT NULL,
  `tanggal` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi_masuk`
--

INSERT INTO `transaksi_masuk` (`id`, `produk_id`, `jumlah`, `tanggal`) VALUES
(43, 208, 5, '2024-12-18 00:45:48'),
(44, 270, 3, '2024-12-18 00:45:54'),
(45, 537, 5, '2024-12-18 00:46:58'),
(46, 726, 5, '2024-12-18 00:47:04');

-- --------------------------------------------------------

--
-- Table structure for table `transaksi_unormalized`
--

CREATE TABLE `transaksi_unormalized` (
  `id` int(11) NOT NULL,
  `produk_id` int(11) DEFAULT NULL,
  `nama_produk` varchar(255) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL,
  `harga` decimal(10,2) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `jumlah_masuk` int(11) DEFAULT NULL,
  `jumlah_keluar` int(11) DEFAULT NULL,
  `tanggal_masuk` timestamp NOT NULL DEFAULT current_timestamp(),
  `tanggal_keluar` timestamp NOT NULL DEFAULT current_timestamp(),
  `username` varchar(50) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `supplier` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transaksi_unormalized`
--

INSERT INTO `transaksi_unormalized` (`id`, `produk_id`, `nama_produk`, `stok`, `harga`, `foto`, `jumlah_masuk`, `jumlah_keluar`, `tanggal_masuk`, `tanggal_keluar`, `username`, `password`, `supplier`) VALUES
(13, 390, 'Burger Bernadi Isi 20 Biji', 15, 34000.00, 'IMG_20240615_183805.jpg', 15, 0, '2024-12-16 02:07:39', '2024-12-16 02:07:39', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(14, 899, 'Fish Dumpling Chicken Cedea', 20, 18000.00, 'IMG_20240615_183816.jpg', 20, 0, '2024-12-16 02:08:25', '2024-12-16 02:08:25', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(15, 227, 'Ikan Olahan ILM', 25, 15000.00, 'IMG_20240615_183824.jpg', 25, 0, '2024-12-16 02:08:48', '2024-12-16 02:08:48', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(16, 546, 'Bakso Ayam Salam 500G', 20, 17000.00, 'IMG_20240615_183833.jpg', 20, 0, '2024-12-16 02:09:35', '2024-12-16 02:09:35', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(17, 153, 'Cumi Flower Indomina', 10, 15000.00, 'IMG_20240615_183839.jpg', 10, 0, '2024-12-16 02:10:46', '2024-12-16 02:10:46', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(18, 805, 'Sosis Bakar SoNice Isi 10', 15, 26500.00, 'IMG_20240615_183851.jpg', 15, 0, '2024-12-16 02:12:32', '2024-12-16 02:12:32', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(19, 528, 'Sosis Bakar Salam', 10, 17000.00, 'IMG_20240615_183910.jpg', 10, 0, '2024-12-16 02:12:59', '2024-12-16 02:12:59', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(20, 157, 'Sosis Ayam Merah Salam 750G', 10, 35000.00, 'IMG_20240615_183918.jpg', 10, 0, '2024-12-16 02:14:10', '2024-12-16 02:14:10', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(21, 868, 'Naget Ayam Ngetop 500G', 15, 14000.00, 'IMG_20240615_184006.jpg', 15, 0, '2024-12-16 02:14:31', '2024-12-16 02:14:31', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(22, 949, 'Chicken Nugget Bartoz 500G', 10, 17500.00, 'IMG_20240615_184013.jpg', 10, 0, '2024-12-16 02:16:35', '2024-12-16 02:16:35', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(23, 534, 'Sosis Sapi Yona Isi 7', 15, 22000.00, 'IMG_20240615_184019.jpg', 15, 0, '2024-12-16 02:17:44', '2024-12-16 02:17:44', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(24, 305, 'Chicken Nugget Akumo 500G', 10, 14000.00, 'IMG_20240615_184024.jpg', 10, 0, '2024-12-16 02:18:10', '2024-12-16 02:18:10', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(25, 141, 'Chicken Nugget GoldStar Angka', 25, 43000.00, 'IMG_20240615_184032.jpg', 25, 0, '2024-12-16 02:19:33', '2024-12-16 02:19:33', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(26, 764, 'Scallop Umia-mi Isi 45', 10, 9000.00, 'IMG_20240615_184035.jpg', 10, 0, '2024-12-16 02:20:29', '2024-12-16 02:20:29', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(27, 253, 'Chicken Nugget Vitalia', 15, 13000.00, 'IMG_20240615_184040.jpg', 15, 0, '2024-12-16 02:20:57', '2024-12-16 02:20:57', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(28, 245, 'Naget Ayam Asimo 450G', 15, 17000.00, 'IMG_20240615_184049.jpg', 15, 0, '2024-12-16 02:21:29', '2024-12-16 02:21:29', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(29, 124, 'Crispy Chicken Nugget Kanzler', 25, 47000.00, 'IMG_20240615_184056.jpg', 25, 0, '2024-12-16 02:22:15', '2024-12-16 02:22:15', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(30, 193, 'Beef Cocktail Sausage Kanzler', 10, 41500.00, 'IMG_20240615_184100.jpg', 10, 0, '2024-12-16 02:22:54', '2024-12-16 02:22:54', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(31, 633, 'Nugget Coin Uenaaak', 15, 23000.00, 'IMG_20240615_184109.jpg', 15, 0, '2024-12-16 02:23:22', '2024-12-16 02:23:22', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(32, 786, 'Naget Ayam Salam 1000G', 15, 36000.00, 'IMG_20240615_184123.jpg', 15, 0, '2024-12-16 02:23:45', '2024-12-16 02:23:45', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(33, 557, 'Mini Pao umia-mi Isi 30', 10, 25000.00, 'IMG_20240615_184142.jpg', 10, 0, '2024-12-16 02:24:51', '2024-12-16 02:24:51', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(34, 451, 'Chicken Karaage Goldstar 500G', 10, 25000.00, 'IMG_20240615_184159.jpg', 10, 0, '2024-12-16 02:25:26', '2024-12-16 02:25:26', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(35, 199, 'Cireng Nikmat Rasa Isi 105', 15, 12500.00, 'IMG-20240305-WA0077.jpg', 15, 0, '2024-12-16 02:26:08', '2024-12-16 02:26:08', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(36, 405, 'Cireng Telor Nikmat Rasa', 10, 14000.00, 'IMG-20240305-WA0078.jpg', 10, 0, '2024-12-16 02:26:36', '2024-12-16 02:26:36', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(37, 465, 'Cireng Merah Rani Food', 10, 9000.00, 'IMG-20240305-WA0079.jpg', 10, 0, '2024-12-16 02:27:03', '2024-12-16 02:27:03', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(38, 673, 'Naget Ayam S Asimo', 10, 16000.00, 'IMG-20240305-WA0080.jpg', 10, 0, '2024-12-16 02:27:35', '2024-12-16 02:27:35', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(39, 208, 'Bakso Sapi Vitalia', 15, 11000.00, 'IMG-20240305-WA0082.jpg', 15, 0, '2024-12-16 02:28:01', '2024-12-16 02:28:01', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(40, 411, 'Sosis Daging Kamil 80G', 30, 12000.00, 'IMG-20240305-WA0083.jpg', 30, 0, '2024-12-16 02:28:34', '2024-12-16 02:28:34', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(41, 495, 'Mariyam Pandan', 15, 15000.00, 'IMG-20240305-WA0085.jpg', 15, 0, '2024-12-16 02:29:14', '2024-12-16 02:29:14', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(42, 180, 'Scalop FirstGrade', 10, 10000.00, 'IMG-20240305-WA0086.jpg', 10, 0, '2024-12-16 02:29:51', '2024-12-16 02:29:51', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(43, 444, 'Bakso Ikan FirstGrade 500G', 10, 14000.00, 'IMG-20240305-WA0087.jpg', 10, 0, '2024-12-16 02:30:20', '2024-12-16 02:30:20', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(44, 380, 'Sosis Sapi Umia-mi Extra 2Pcs', 25, 26000.00, 'IMG-20240305-WA0088.jpg', 25, 0, '2024-12-16 02:30:56', '2024-12-16 02:30:56', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(45, 270, 'Burger Sapi Vitalia 280G', 20, 15000.00, 'IMG-20240305-WA0089.jpg', 20, 0, '2024-12-16 02:31:29', '2024-12-16 02:31:29', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(46, 434, 'Udang Gulung JS Isi 22', 5, 14000.00, 'IMG-20240305-WA0091.jpg', 5, 0, '2024-12-16 02:33:43', '2024-12-16 02:33:43', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(47, 944, 'Ikan Olahan Bintang ILM 500G', 10, 17000.00, 'IMG-20240305-WA0092.jpg', 10, 0, '2024-12-16 02:34:06', '2024-12-16 02:34:06', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(48, 520, 'Mariyam Original', 15, 12000.00, 'IMG-20240305-WA0093.jpg', 15, 0, '2024-12-16 02:34:27', '2024-12-16 02:34:27', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(49, 850, 'Mariyam Coklat', 10, 12000.00, 'IMG-20240305-WA0094.jpg', 10, 0, '2024-12-16 02:34:47', '2024-12-16 02:34:47', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(50, 399, 'Sosis Bakar Muantap', 10, 14000.00, 'IMG-20240305-WA0096.jpg', 10, 0, '2024-12-16 02:35:13', '2024-12-16 02:35:13', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(51, 991, 'Sosis Ayam Champ', 10, 26500.00, 'IMG-20240305-WA0097.jpg', 10, 0, '2024-12-16 02:35:39', '2024-12-16 02:35:39', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(52, 384, 'Chicken Sausage Champ IsI 3', 50, 14000.00, 'IMG-20240305-WA0098.jpg', 50, 0, '2024-12-16 02:36:20', '2024-12-16 02:36:20', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(53, 572, 'Beef Sausage Champ Isi 6', 25, 17000.00, 'IMG-20240305-WA0099.jpg', 25, 0, '2024-12-16 02:36:53', '2024-12-16 02:36:53', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(54, 726, 'French Fries 808', 10, 21000.00, 'IMG-20240305-WA0101.jpg', 10, 0, '2024-12-16 02:37:22', '2024-12-16 02:37:22', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(55, 449, 'Sosis Bakar Salam Isi 12', 10, 21000.00, 'IMG-20240305-WA0102.jpg', 10, 0, '2024-12-16 02:38:01', '2024-12-16 02:38:01', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(56, 617, 'French Fries Fiesta', 25, 23000.00, 'IMG-20240305-WA0110.jpg', 25, 0, '2024-12-16 02:38:47', '2024-12-16 02:38:47', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(57, 609, 'Crispy Chicken Nugget GoldStar', 10, 21000.00, 'IMG-20240305-WA0113.jpg', 10, 0, '2024-12-16 02:39:12', '2024-12-16 02:39:12', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(58, 601, 'Bakso Sapi Kamil', 15, 17000.00, 'IMG-20240305-WA0117.jpg', 15, 0, '2024-12-16 02:39:37', '2024-12-16 02:39:37', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(59, 995, 'Sosis Merah Ngetop 500G', 5, 18000.00, 'IMG-20240305-WA0118.jpg', 5, 0, '2024-12-16 02:40:03', '2024-12-16 02:40:03', 'admin', 'admin123', 'Murtiasih Frozen Food'),
(60, 537, 'Bakso Aci Gendhis', 20, 8000.00, 'IMG-20240615-WA0027.jpg', 20, 0, '2024-12-16 02:40:34', '2024-12-16 02:40:34', 'admin', 'admin123', 'Murtiasih Frozen Food');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('admin','owner') NOT NULL DEFAULT 'admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`) VALUES
(1, 'staff', '1', 'admin'),
(5, 'owner', '2', 'owner'),
(10, 'staff2', '3', 'admin');

-- --------------------------------------------------------

--
-- Structure for view `barangterlaris`
--
DROP TABLE IF EXISTS `barangterlaris`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `barangterlaris`  AS SELECT `transaksi`.`nama_produk` AS `nama_produk`, sum(`transaksi`.`jumlah_terjual`) AS `total_terjual` FROM `transaksi` GROUP BY `transaksi`.`nama_produk` ORDER BY sum(`transaksi`.`jumlah_terjual`) DESC ;

-- --------------------------------------------------------

--
-- Structure for view `penjualantertinggi`
--
DROP TABLE IF EXISTS `penjualantertinggi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `penjualantertinggi`  AS SELECT date_format(`transaksi`.`tanggal`,'%Y-%m') AS `bulan`, sum(`transaksi`.`total_harga`) AS `total_penjualan` FROM `transaksi` GROUP BY date_format(`transaksi`.`tanggal`,'%Y-%m') ORDER BY sum(`transaksi`.`total_harga`) DESC LIMIT 0, 3 ;

-- --------------------------------------------------------

--
-- Structure for view `produk_view`
--
DROP TABLE IF EXISTS `produk_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `produk_view`  AS SELECT `produk`.`id` AS `id`, `produk`.`nama` AS `nama`, `produk`.`harga` AS `harga`, `produk`.`stok` AS `stok` FROM `produk` ;

-- --------------------------------------------------------

--
-- Structure for view `stok_produk_view`
--
DROP TABLE IF EXISTS `stok_produk_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `stok_produk_view`  AS SELECT `p`.`nama` AS `nama_produk`, `p`.`stok` AS `stok` FROM `produk` AS `p` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `transaction_id` (`transaction_id`);

--
-- Indexes for table `transaction_header`
--
ALTER TABLE `transaction_header`
  ADD PRIMARY KEY (`transaction_id`);

--
-- Indexes for table `transaksi`
--
ALTER TABLE `transaksi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transaksi_keluar`
--
ALTER TABLE `transaksi_keluar`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `transaksi_masuk`
--
ALTER TABLE `transaksi_masuk`
  ADD PRIMARY KEY (`id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `transaksi_unormalized`
--
ALTER TABLE `transaksi_unormalized`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=996;

--
-- AUTO_INCREMENT for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  MODIFY `detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `transaction_header`
--
ALTER TABLE `transaction_header`
  MODIFY `transaction_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `transaksi`
--
ALTER TABLE `transaksi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `transaksi_keluar`
--
ALTER TABLE `transaksi_keluar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `transaksi_masuk`
--
ALTER TABLE `transaksi_masuk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `transaksi_unormalized`
--
ALTER TABLE `transaksi_unormalized`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `transaction_detail`
--
ALTER TABLE `transaction_detail`
  ADD CONSTRAINT `transaction_detail_ibfk_1` FOREIGN KEY (`transaction_id`) REFERENCES `transaction_header` (`transaction_id`);

--
-- Constraints for table `transaksi_keluar`
--
ALTER TABLE `transaksi_keluar`
  ADD CONSTRAINT `transaksi_keluar_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`);

--
-- Constraints for table `transaksi_masuk`
--
ALTER TABLE `transaksi_masuk`
  ADD CONSTRAINT `transaksi_masuk_ibfk_1` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
