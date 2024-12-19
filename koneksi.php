<?php
// Koneksi ke database MySQL
$servername = "localhost";
$username = "root";  // Default untuk XAMPP
$password = "";  // Default untuk XAMPP
$dbname = "frozen_food";  // Nama database yang sudah dibuat

// Membuat koneksi
$conn = new mysqli($servername, $username, $password, $dbname);

// Mengecek koneksi
if ($conn->connect_error) {
    die("Koneksi gagal: " . $conn->connect_error);
}
?>