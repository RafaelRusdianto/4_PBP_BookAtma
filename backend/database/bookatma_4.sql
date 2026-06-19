-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 15, 2026 at 02:08 PM
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
-- Database: `bookatma_4`
--

-- --------------------------------------------------------

--
-- Table structure for table `booking`
--

CREATE TABLE `booking` (
  `id_booking` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `tgl_booking` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `check_in` date DEFAULT NULL,
  `check_out` date DEFAULT NULL,
  `total_harga` decimal(12,2) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `breakfast` tinyint(1) NOT NULL DEFAULT 0,
  `laundry` tinyint(1) NOT NULL DEFAULT 0,
  `airport_pickup` tinyint(1) NOT NULL DEFAULT 0,
  `special_request` varchar(255) DEFAULT NULL,
  `note` text DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT 'BCA Virtual Account',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`id_booking`, `id_user`, `tgl_booking`, `check_in`, `check_out`, `total_harga`, `status`, `breakfast`, `laundry`, `airport_pickup`, `special_request`, `note`, `payment_method`, `created_at`, `updated_at`) VALUES
(101, 101, '2026-05-01 03:15:00', '2026-06-01', '2026-06-03', 1000000.00, 'confirmed', 0, 0, 0, NULL, NULL, 'BCA Virtual Account', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 102, '2026-05-03 07:20:00', '2026-06-05', '2026-06-08', 2700000.00, 'confirmed', 1, 0, 1, 'Lantai Tinggi', 'Butuh bantal tambahan', 'Mandiri Virtual Account', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 103, '2026-05-05 02:30:00', '2026-06-10', '2026-06-12', 900000.00, 'pending', 0, 0, 0, NULL, NULL, 'GoPay', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 104, '2026-05-07 04:00:00', '2026-06-15', '2026-06-18', 2550000.00, 'confirmed', 1, 1, 0, 'Kamar Bebas Rokok', 'Check-in jam 10 malam', 'BCA Virtual Account', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 105, '2026-05-09 09:45:00', '2026-06-20', '2026-06-22', 3000000.00, 'cancelled', 0, 0, 0, NULL, NULL, 'DANA', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 101, '2026-05-11 01:10:00', '2026-07-01', '2026-07-04', 3300000.00, 'confirmed', 1, 0, 1, 'Pintu Terhubung', 'Kamar untuk 2 orang dewasa', 'Mandiri Virtual Account', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 102, '2026-05-13 06:25:00', '2026-07-05', '2026-07-07', 3200000.00, 'pending', 0, 0, 0, NULL, NULL, 'GoPay', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 103, '2026-05-15 12:40:00', '2026-07-10', '2026-07-12', 2200000.00, 'confirmed', 0, 0, 0, NULL, 'Trip keluarga', 'BCA Virtual Account', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_booking`
--

CREATE TABLE `detail_booking` (
  `id_detail_booking` int(11) NOT NULL,
  `id_kamar` int(11) DEFAULT NULL,
  `id_booking` int(11) DEFAULT NULL,
  `harga_per_malam` decimal(10,2) DEFAULT NULL,
  `jumlah_malam` int(11) DEFAULT NULL,
  `subtotal` decimal(12,2) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `detail_booking`
--

INSERT INTO `detail_booking` (`id_detail_booking`, `id_kamar`, `id_booking`, `harga_per_malam`, `jumlah_malam`, `subtotal`, `created_at`, `updated_at`) VALUES
(101, 102, 101, 500000.00, 2, 1000000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 105, 102, 900000.00, 3, 2700000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 108, 103, 450000.00, 2, 900000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 111, 104, 850000.00, 3, 2550000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 113, 105, 1500000.00, 2, 3000000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 117, 106, 1100000.00, 3, 3300000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 118, 107, 1600000.00, 2, 3200000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 117, 108, 1100000.00, 2, 2200000.00, '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas`
--

CREATE TABLE `fasilitas` (
  `id_fasilitas` int(11) NOT NULL,
  `nama_fasilitas` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas`
--

INSERT INTO `fasilitas` (`id_fasilitas`, `nama_fasilitas`, `created_at`, `updated_at`) VALUES
(101, 'WiFi Gratis', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 'AC', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 'TV LED', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 'Kamar Mandi Dalam', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 'Sarapan', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 'Kolam Renang', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 'Parkir Gratis', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 'Mini Bar', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 'Bathtub', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 'Balkon', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `fasilitas_kamar`
--

CREATE TABLE `fasilitas_kamar` (
  `id_kamar` int(11) NOT NULL,
  `id_fasilitas` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `fasilitas_kamar`
--

INSERT INTO `fasilitas_kamar` (`id_kamar`, `id_fasilitas`, `created_at`, `updated_at`) VALUES
(101, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(101, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(101, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 105, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 109, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 104, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 110, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 105, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 109, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 110, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 106, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 108, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 106, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 108, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 110, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 110, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 107, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 105, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 107, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 101, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 102, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 103, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 107, '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `hotel`
--

CREATE TABLE `hotel` (
  `id_hotel` int(11) NOT NULL,
  `id_provinsi` int(11) DEFAULT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `avg_rating` decimal(2,1) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel`
--

INSERT INTO `hotel` (`id_hotel`, `id_provinsi`, `nama`, `alamat`, `avg_rating`, `deskripsi`, `created_at`, `updated_at`) VALUES
(101, 101, 'Atma Stay Malioboro', 'Jl. Malioboro No. 10, Yogyakarta', 4.7, 'Hotel nyaman di pusat kota dekat area wisata dan kuliner.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 101, 'Jogja Heritage Hotel', 'Jl. Kaliurang Km. 5, Sleman, Yogyakarta', 4.5, 'Hotel bernuansa heritage dengan fasilitas lengkap untuk keluarga.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 102, 'Semarang City Inn', 'Jl. Pemuda No. 22, Semarang', 4.3, 'Penginapan strategis untuk perjalanan bisnis dan liburan.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 103, 'Bandung Hill Resort', 'Jl. Dago Atas No. 88, Bandung', 4.6, 'Resort dengan pemandangan pegunungan dan udara sejuk.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 104, 'Bali Sunset Villa', 'Jl. Pantai Kuta No. 15, Badung, Bali', 4.8, 'Villa tropis dekat pantai dengan suasana santai.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 105, 'Jakarta Business Hotel', 'Jl. Sudirman No. 101, Jakarta Pusat', 4.4, 'Hotel bisnis modern dekat pusat perkantoran.', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `hotel_foto`
--

CREATE TABLE `hotel_foto` (
  `id_hotel_foto` int(11) NOT NULL,
  `id_hotel` int(11) DEFAULT NULL,
  `url_foto` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `hotel_foto`
--

INSERT INTO `hotel_foto` (`id_hotel_foto`, `id_hotel`, `url_foto`, `created_at`, `updated_at`) VALUES
(101, 101, 'hotels/atma-stay-malioboro-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 101, 'hotels/atma-stay-malioboro-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 102, 'hotels/jogja-heritage-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 103, 'hotels/semarang-city-inn-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 104, 'hotels/bandung-hill-resort-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 105, 'hotels/bali-sunset-villa-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 106, 'hotels/jakarta-business-hotel-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 101, 'hotels/atma-stay-malioboro-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 101, 'hotels/atma-stay-malioboro-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 102, 'hotels/jogja-heritage-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 102, 'hotels/jogja-heritage-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 102, 'hotels/jogja-heritage-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 103, 'hotels/semarang-city-inn-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 103, 'hotels/semarang-city-inn-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 103, 'hotels/semarang-city-inn-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 104, 'hotels/bandung-hill-resort-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 104, 'hotels/bandung-hill-resort-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 104, 'hotels/bandung-hill-resort-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(119, 105, 'hotels/bali-sunset-villa-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(120, 105, 'hotels/bali-sunset-villa-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(121, 105, 'hotels/bali-sunset-villa-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(122, 106, 'hotels/jakarta-business-hotel-2.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(123, 106, 'hotels/jakarta-business-hotel-3.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(124, 106, 'hotels/jakarta-business-hotel-4.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `kamar`
--

CREATE TABLE `kamar` (
  `id_kamar` int(11) NOT NULL,
  `id_hotel` int(11) DEFAULT NULL,
  `nomor_kamar` varchar(10) DEFAULT NULL,
  `tipe_kamar` varchar(50) DEFAULT NULL,
  `harga_per_malam` decimal(10,2) DEFAULT NULL,
  `kapasitas` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `status` enum('available','booked','maintenance') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kamar`
--

INSERT INTO `kamar` (`id_kamar`, `id_hotel`, `nomor_kamar`, `tipe_kamar`, `harga_per_malam`, `kapasitas`, `keterangan`, `status`, `created_at`, `updated_at`) VALUES
(101, 101, '101', 'Standard', 350000.00, 2, 'Kamar standard dengan queen bed.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 101, '102', 'Deluxe', 500000.00, 2, 'Kamar deluxe dengan city view.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 101, '201', 'Family', 750000.00, 4, 'Kamar keluarga dengan dua queen bed.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 102, 'A01', 'Standard', 380000.00, 2, 'Kamar nyaman untuk dua orang.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 102, 'A02', 'Suite', 900000.00, 3, 'Suite luas dengan bathtub.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 102, 'A03', 'Deluxe', 550000.00, 2, 'Deluxe room dekat taman.', 'maintenance', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 103, '301', 'Standard', 300000.00, 2, 'Kamar ekonomis untuk perjalanan singkat.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 103, '302', 'Deluxe', 450000.00, 2, 'Kamar deluxe dengan meja kerja.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 103, '303', 'Twin Room', 420000.00, 2, 'Kamar twin bed untuk rekan kerja.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 104, 'B01', 'Deluxe', 650000.00, 2, 'Kamar dengan pemandangan bukit.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 104, 'B02', 'Family', 850000.00, 4, 'Family room untuk liburan keluarga.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 104, 'B03', 'Suite', 1200000.00, 3, 'Suite premium dengan balkon.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 105, 'V01', 'Villa 1 Bedroom', 1500000.00, 2, 'Villa privat satu kamar dekat pantai.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 105, 'V02', 'Villa 2 Bedroom', 2500000.00, 4, 'Villa keluarga dengan private pool.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 105, 'V03', 'Suite Ocean View', 1800000.00, 2, 'Suite dengan pemandangan laut.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 106, '501', 'Business Room', 700000.00, 2, 'Kamar bisnis dengan meja kerja.', 'available', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 106, '502', 'Executive', 1100000.00, 2, 'Executive room dengan lounge access.', 'booked', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 106, '503', 'Meeting Suite', 1600000.00, 3, 'Suite dengan ruang meeting kecil.', 'maintenance', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `kamar_foto`
--

CREATE TABLE `kamar_foto` (
  `id_kamar_foto` int(11) NOT NULL,
  `id_kamar` int(11) DEFAULT NULL,
  `url_foto` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `kamar_foto`
--

INSERT INTO `kamar_foto` (`id_kamar_foto`, `id_kamar`, `url_foto`, `created_at`, `updated_at`) VALUES
(101, 101, 'rooms/101-standard-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 102, 'rooms/102-deluxe-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 103, 'rooms/201-family-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 104, 'rooms/a01-standard-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 105, 'rooms/a02-suite-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 106, 'rooms/a03-deluxe-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 107, 'rooms/301-standard-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 108, 'rooms/302-deluxe-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(109, 109, 'rooms/303-twin-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(110, 110, 'rooms/b01-deluxe-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(111, 111, 'rooms/b02-family-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(112, 112, 'rooms/b03-suite-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(113, 113, 'rooms/v01-villa-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(114, 114, 'rooms/v02-villa-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(115, 115, 'rooms/v03-ocean-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(116, 116, 'rooms/501-business-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(117, 117, 'rooms/502-executive-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(118, 118, 'rooms/503-meeting-suite-1.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_01_114804_create_personal_access_tokens_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id_pembayaran` int(11) NOT NULL,
  `id_booking` int(11) DEFAULT NULL,
  `kode_transaksi` varchar(100) DEFAULT NULL,
  `metode_pembayaran` varchar(50) DEFAULT 'BCA Virtual Account',
  `jumlah_bayar` decimal(12,2) DEFAULT NULL,
  `status_pembayaran` varchar(50) DEFAULT NULL,
  `tgl_pembayaran` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `pembayaran`
--

INSERT INTO `pembayaran` (`id_pembayaran`, `id_booking`, `kode_transaksi`, `metode_pembayaran`, `jumlah_bayar`, `status_pembayaran`, `tgl_pembayaran`, `created_at`, `updated_at`) VALUES
(101, 101, 'TRX-20260601-001', 'BCA Virtual Account', 1000000.00, 'paid', '2026-05-01 03:30:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 102, 'TRX-20260605-002', 'Mandiri Virtual Account', 2700000.00, 'paid', '2026-05-03 07:45:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 103, 'TRX-20260610-003', 'BCA Virtual Account', 0.00, 'pending', '2026-05-05 02:30:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 104, 'TRX-20260615-004', 'Mandiri Virtual Account', 2550000.00, 'paid', '2026-05-07 04:20:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 105, 'TRX-20260620-005', 'DANA', 0.00, 'cancelled', '2026-05-09 09:45:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(106, 106, 'TRX-20260701-006', 'Mandiri Virtual Account', 3300000.00, 'paid', '2026-05-11 01:40:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(107, 107, 'TRX-20260705-007', 'GoPay', 0.00, 'pending', '2026-05-13 06:25:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(108, 108, 'TRX-20260710-008', 'BCA Virtual Account', 2200000.00, 'paid', '2026-05-15 13:00:00', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\User', 1, 'auth_token', '1bc00cf37dbcb4bc3971afe689dfda9d1f90df9d423d190b4a83dc806d57a5ff', '[\"*\"]', NULL, NULL, '2026-04-06 23:08:17', '2026-04-06 23:08:17'),
(3, 'App\\Models\\User', 3, 'auth_token', '50df4ddd82d2338d10f69a69bbabbaee887757fb059f633146e4a704c3dacb61', '[\"*\"]', NULL, NULL, '2026-05-21 01:53:32', '2026-05-21 01:53:32'),
(4, 'App\\Models\\User', 3, 'auth_token', '0cb8b21a2efb67a932fcca97b2a7d3627702e4352c197c68726ff1cab88fa4f8', '[\"*\"]', NULL, NULL, '2026-05-21 01:53:49', '2026-05-21 01:53:49'),
(5, 'App\\Models\\User', 3, 'auth_token', '31a7745daf0f5a779eedd81a80c9f0b542bd380d33327a96b25c35b75be11cdc', '[\"*\"]', NULL, NULL, '2026-05-21 02:06:52', '2026-05-21 02:06:52'),
(6, 'App\\Models\\User', 3, 'auth_token', '285b09f01dd2223f937557dc8b5d1fe3556e018a852285b7dc61fce582cc8d12', '[\"*\"]', NULL, NULL, '2026-05-21 02:24:49', '2026-05-21 02:24:49'),
(7, 'App\\Models\\User', 3, 'auth_token', 'bfd6308518adb569e254872ec0a0da28c3ecd878f33ca746644a42d823f1ad27', '[\"*\"]', NULL, NULL, '2026-05-21 03:00:07', '2026-05-21 03:00:07'),
(8, 'App\\Models\\User', 3, 'auth_token', 'b80da9c857245a160681352f5a52e3d35616c760ce8285194fbc7d009f6c208f', '[\"*\"]', NULL, NULL, '2026-06-03 07:37:14', '2026-06-03 07:37:14'),
(9, 'App\\Models\\User', 3, 'auth_token', '797d2a6e19fed88a5ab031f76d4ca776e61de6d7ba9374d446ea41224d3a6646', '[\"*\"]', NULL, NULL, '2026-06-03 08:00:16', '2026-06-03 08:00:16'),
(10, 'App\\Models\\User', 3, 'auth_token', '423f6b209fdea555d704f92fda82f72184cbbed16414aaa74ef74fd346ed018c', '[\"*\"]', NULL, NULL, '2026-06-03 23:36:56', '2026-06-03 23:36:56'),
(11, 'App\\Models\\User', 3, 'auth_token', 'a8c0437d201dff284e0543d7dab6285b7523bb110c2e500afd49a72b404f6fc9', '[\"*\"]', NULL, NULL, '2026-06-03 23:45:37', '2026-06-03 23:45:37'),
(12, 'App\\Models\\User', 3, 'auth_token', 'a8a757833284df6dbeadf0e4214d99d0327adf04979e7df1ae34abc6418beb34', '[\"*\"]', NULL, NULL, '2026-06-04 00:00:16', '2026-06-04 00:00:16'),
(13, 'App\\Models\\User', 3, 'auth_token', 'e908a380fb0a46d7f7a95f2292fcc775c9dd8cd235c06177ca2ccee3a37685bb', '[\"*\"]', NULL, NULL, '2026-06-04 00:01:03', '2026-06-04 00:01:03'),
(14, 'App\\Models\\User', 3, 'auth_token', '6ff4fd53b7c7e98ca8adfd72268440d6e45165ce6ac44d5549f6fcb5ddac05a9', '[\"*\"]', NULL, NULL, '2026-06-04 04:58:44', '2026-06-04 04:58:44'),
(15, 'App\\Models\\User', 101, 'auth_token', '502d4f3f98ef99cd85ffc33d01f0c3114808bb70dbb14215425cb40b516602ca', '[\"*\"]', NULL, NULL, '2026-06-09 01:23:21', '2026-06-09 01:23:21'),
(16, 'App\\Models\\User', 101, 'auth_token', 'b5dc02261e8ab6df7415d7f44ba5fd2acbab2598ae310fff1e76545b85f4cdf6', '[\"*\"]', NULL, NULL, '2026-06-09 01:24:32', '2026-06-09 01:24:32');

-- --------------------------------------------------------

--
-- Table structure for table `provinsi`
--

CREATE TABLE `provinsi` (
  `id_provinsi` int(11) NOT NULL,
  `nama_provinsi` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `provinsi`
--

INSERT INTO `provinsi` (`id_provinsi`, `nama_provinsi`) VALUES
(101, 'DI Yogyakarta'),
(102, 'Jawa Tengah'),
(103, 'Jawa Barat'),
(104, 'Bali'),
(105, 'DKI Jakarta');

-- --------------------------------------------------------

--
-- Table structure for table `review`
--

CREATE TABLE `review` (
  `id_review` int(11) NOT NULL,
  `id_pembayaran` int(11) DEFAULT NULL,
  `id_hotel` int(11) DEFAULT NULL,
  `rating` int(11) DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `review_foto`
--

CREATE TABLE `review_foto` (
  `id_review_foto` int(11) NOT NULL,
  `id_review` int(11) NOT NULL,
  `url_foto` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `review`
--

INSERT INTO `review` (`id_review`, `id_pembayaran`, `id_hotel`, `rating`, `keterangan`, `created_at`, `updated_at`) VALUES
(101, 101, 101, 5, 'Lokasi strategis dan kamar bersih. Cocok untuk liburan singkat.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(102, 102, 102, 4, 'Fasilitas lengkap dan suasana nyaman, hanya parkir agak ramai.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 104, 104, 5, 'Pemandangan bagus dan pelayanan ramah.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 106, 106, 4, 'Sangat cocok untuk perjalanan bisnis. Akses mudah ke pusat kota.', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 108, 106, 5, 'Kamar executive nyaman dan proses check-in cepat.', '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('vFsCP0JJdlfNLiiFhiQkA8mtvlFxmImPpeLPl2uF', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiaVNWNmkyTkl3djQxT05KbTV3V3lWVDJtTmZzVnJjTHpKNzl4aGlpTyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1774981972),
('yYm5SvblXHQWPY7WTCnvaNTfGpLFC77GQBZKzy7I', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Code/1.120.0 Chrome/142.0.7444.265 Electron/39.8.8 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWEdFVWpFZE5tRXBudUVGd0EzZXZRZjZZdW5obXVEUTA0aGZrSjRGNyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1779351700);

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_user` int(11) NOT NULL,
  `nama` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_user`, `nama`, `email`, `password`, `no_hp`, `foto_profil`, `created_at`, `updated_at`) VALUES
(1, 'Filbert', 'asd@gmail.com', '$2y$12$qL0X7FHbkETBERAq.RF3Z.O6LDBs04CpPhArt3t0YZN3mk7qmoQHK', '123412341234', NULL, '2026-04-07 06:03:39', '2026-04-07 06:03:39'),
(2, 'Filbert', 'filbert@gmail.com', '$2y$12$tMygf9gm.POFIrAtoUwR5Oxb4kT.4f1VC4j8tsY1HLkyKmteI5ASa', '123412341234', NULL, '2026-04-07 06:07:55', '2026-04-07 06:07:55'),
(3, 'rafael', 'rafael@gmail.com', '$2y$12$CA.04HfxLCQ9TcFe7At.8OHGZlylgeJdzzUufMaNlAIu37JeQlazW', '1234567890', NULL, '2026-05-21 08:52:52', '2026-05-21 08:52:52'),
(101, 'Andi Pratama', 'andi.test@example.com', '$2y$12$CA.04HfxLCQ9TcFe7At.8OHGZlylgeJdzzUufMaNlAIu37JeQlazW', '081234567801', 'profiles/andi.jpg', '2026-05-29 13:53:08', '2026-06-09 08:23:17'),
(102, 'Siti Rahma', 'siti.test@example.com', '$2y$12$dummyhashdummyhashdummyhashdummyhashdummyhashdummyhash', '081234567802', 'profiles/siti.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(103, 'Budi Santoso', 'budi.test@example.com', '$2y$12$dummyhashdummyhashdummyhashdummyhashdummyhashdummyhash', '081234567803', 'profiles/budi.jpg', '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(104, 'Dewi Lestari', 'dewi.test@example.com', '$2y$12$dummyhashdummyhashdummyhashdummyhashdummyhashdummyhash', '081234567804', NULL, '2026-05-29 13:53:08', '2026-05-29 13:53:08'),
(105, 'Rizky Maulana', 'rizky.test@example.com', '$2y$12$dummyhashdummyhashdummyhashdummyhashdummyhashdummyhash', '081234567805', NULL, '2026-05-29 13:53:08', '2026-05-29 13:53:08');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`id_booking`),
  ADD KEY `id_user` (`id_user`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `detail_booking`
--
ALTER TABLE `detail_booking`
  ADD PRIMARY KEY (`id_detail_booking`),
  ADD KEY `id_kamar` (`id_kamar`),
  ADD KEY `id_booking` (`id_booking`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `fasilitas`
--
ALTER TABLE `fasilitas`
  ADD PRIMARY KEY (`id_fasilitas`);

--
-- Indexes for table `fasilitas_kamar`
--
ALTER TABLE `fasilitas_kamar`
  ADD PRIMARY KEY (`id_kamar`,`id_fasilitas`),
  ADD KEY `id_fasilitas` (`id_fasilitas`);

--
-- Indexes for table `hotel`
--
ALTER TABLE `hotel`
  ADD PRIMARY KEY (`id_hotel`),
  ADD KEY `id_provinsi` (`id_provinsi`);

--
-- Indexes for table `hotel_foto`
--
ALTER TABLE `hotel_foto`
  ADD PRIMARY KEY (`id_hotel_foto`),
  ADD KEY `id_hotel` (`id_hotel`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `kamar`
--
ALTER TABLE `kamar`
  ADD PRIMARY KEY (`id_kamar`),
  ADD KEY `id_hotel` (`id_hotel`);

--
-- Indexes for table `kamar_foto`
--
ALTER TABLE `kamar_foto`
  ADD PRIMARY KEY (`id_kamar_foto`),
  ADD KEY `id_kamar` (`id_kamar`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id_pembayaran`),
  ADD KEY `id_booking` (`id_booking`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `provinsi`
--
ALTER TABLE `provinsi`
  ADD PRIMARY KEY (`id_provinsi`);

--
-- Indexes for table `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`id_review`),
  ADD KEY `id_pembayaran` (`id_pembayaran`),
  ADD KEY `id_hotel` (`id_hotel`);

--
-- Indexes for table `review_foto`
--
ALTER TABLE `review_foto`
  ADD PRIMARY KEY (`id_review_foto`),
  ADD KEY `id_review` (`id_review`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `id_booking` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `detail_booking`
--
ALTER TABLE `detail_booking`
  MODIFY `id_detail_booking` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `fasilitas`
--
ALTER TABLE `fasilitas`
  MODIFY `id_fasilitas` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=111;

--
-- AUTO_INCREMENT for table `hotel`
--
ALTER TABLE `hotel`
  MODIFY `id_hotel` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `hotel_foto`
--
ALTER TABLE `hotel_foto`
  MODIFY `id_hotel_foto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=125;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `kamar`
--
ALTER TABLE `kamar`
  MODIFY `id_kamar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `kamar_foto`
--
ALTER TABLE `kamar_foto`
  MODIFY `id_kamar_foto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=119;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id_pembayaran` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `provinsi`
--
ALTER TABLE `provinsi`
  MODIFY `id_provinsi` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `review`
--
ALTER TABLE `review`
  MODIFY `id_review` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `review_foto`
--
ALTER TABLE `review_foto`
  MODIFY `id_review_foto` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=106;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`id_user`) REFERENCES `user` (`id_user`);

--
-- Constraints for table `detail_booking`
--
ALTER TABLE `detail_booking`
  ADD CONSTRAINT `detail_booking_ibfk_1` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`),
  ADD CONSTRAINT `detail_booking_ibfk_2` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`);

--
-- Constraints for table `fasilitas_kamar`
--
ALTER TABLE `fasilitas_kamar`
  ADD CONSTRAINT `fasilitas_kamar_ibfk_1` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`),
  ADD CONSTRAINT `fasilitas_kamar_ibfk_2` FOREIGN KEY (`id_fasilitas`) REFERENCES `fasilitas` (`id_fasilitas`);

--
-- Constraints for table `hotel`
--
ALTER TABLE `hotel`
  ADD CONSTRAINT `hotel_ibfk_1` FOREIGN KEY (`id_provinsi`) REFERENCES `provinsi` (`id_provinsi`);

--
-- Constraints for table `hotel_foto`
--
ALTER TABLE `hotel_foto`
  ADD CONSTRAINT `hotel_foto_ibfk_1` FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`);

--
-- Constraints for table `kamar`
--
ALTER TABLE `kamar`
  ADD CONSTRAINT `kamar_ibfk_1` FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`);

--
-- Constraints for table `kamar_foto`
--
ALTER TABLE `kamar_foto`
  ADD CONSTRAINT `kamar_foto_ibfk_1` FOREIGN KEY (`id_kamar`) REFERENCES `kamar` (`id_kamar`);

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_ibfk_1` FOREIGN KEY (`id_booking`) REFERENCES `booking` (`id_booking`);

--
-- Constraints for table `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`id_pembayaran`) REFERENCES `pembayaran` (`id_pembayaran`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`id_hotel`) REFERENCES `hotel` (`id_hotel`);

--
-- Constraints for table `review_foto`
--
ALTER TABLE `review_foto`
  ADD CONSTRAINT `review_foto_ibfk_1` FOREIGN KEY (`id_review`) REFERENCES `review` (`id_review`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
