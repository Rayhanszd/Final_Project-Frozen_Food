<?php
// Mulai session
session_start();

// Periksa apakah pengguna sudah login
if (!isset($_SESSION['username'])) {
    header('Location: login.php'); // Arahkan ke halaman login jika belum login
    exit;
}

// Koneksi ke database
include 'koneksi.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $produk_id = $_POST['produk_id'];
    $jumlah = $_POST['jumlah_masuk'];

    // Insert transaksi barang masuk
    $sql_masuk = "INSERT INTO transaksi_masuk (produk_id, jumlah) VALUES ('$produk_id', '$jumlah')";
    if ($conn->query($sql_masuk) === TRUE) {
        // Update stok produk
        $sql_update_stok = "UPDATE produk SET stok = stok + $jumlah WHERE id = $produk_id";
        $conn->query($sql_update_stok);
        echo "<script>alert('Barang berhasil ditambahkan ke stok!'); window.location.href='input_masuk.php';</script>";
} else {
        echo "Terjadi kesalahan: " . $conn->error;
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Input Barang Masuk</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="container">
        <h1>Input Barang Masuk</h1>
        <form action="input_masuk.php" method="POST">
            <div class="form-container">
                <label for="produk_id">Pilih Produk</label>
                <select name="produk_id" id="produk_id" required>
                    <option value="">-- Pilih Produk --</option>
                    <?php
                    // Menampilkan daftar produk
                    $sql = "SELECT id, nama FROM produk";
                    $result = $conn->query($sql);
                    while ($row = $result->fetch_assoc()) {
                        echo "<option value='" . $row['id'] . "'>" . $row['nama'] . "</option>";
                    }
                    ?>
                </select>

                <label for="jumlah_masuk">Jumlah Barang Masuk</label>
                <input type="number" name="jumlah_masuk" id="jumlah_masuk" required min="1" placeholder="Masukkan jumlah barang" />

                <button type="submit">Tambahkan Stok</button>
            </div>
        </form>

        <a href="dashboard_admin.php" class="back-button">Kembali ke Dashboard</a>
    </div>

</body>
</html>
