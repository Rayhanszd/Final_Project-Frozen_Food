<?php
// Koneksi ke database
include 'koneksi.php';

// Proses jika formulir disubmit
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'];
    $stok = $_POST['stok'];
    $harga = str_replace('.', '', $_POST['harga']); // Menghapus titik dari harga yang diformat
    $supplier = $_POST['supplier']; // Menangkap nama suplier dari input
    $id = rand(100, 999); // Membuat ID acak antara 100 dan 999

    // Proses upload file gambar
    $foto = $_FILES['foto']['name'];
    $foto_tmp = $_FILES['foto']['tmp_name'];
    $foto_path = "uploads/" . basename($foto);
    
    if (move_uploaded_file($foto_tmp, $foto_path)) {
        // Query untuk memasukkan data produk ke tabel produk
        $sql_produk = "INSERT INTO produk (id, nama, stok, harga, foto, supplier) 
                       VALUES ('$id', '$nama', $stok, $harga, '$foto', '$supplier')";
        
        if ($conn->query($sql_produk) === TRUE) {
            // Menambahkan data ke tabel transaksi_unormalized
            $username = "admin"; // Atau ambil dari sesi pengguna yang login
            $password = "admin123"; // Atau ambil dari sesi pengguna yang login
            $jumlah_masuk = $stok; // Menggunakan stok sebagai jumlah masuk
            $jumlah_keluar = 0; // Awalnya tidak ada barang keluar

            // Query untuk memasukkan data ke transaksi_unormalized
            $sql_transaksi = "INSERT INTO transaksi_unormalized (produk_id, nama_produk, stok, harga, foto, jumlah_masuk, jumlah_keluar, tanggal_masuk, tanggal_keluar, username, password, supplier)
                              VALUES ('$id', '$nama', '$stok', '$harga', '$foto', '$jumlah_masuk', '$jumlah_keluar', NOW(), NOW(), '$username', '$password', '$supplier')";

            if ($conn->query($sql_transaksi) === TRUE) {
                // Data berhasil ditambahkan
                $_SESSION['success_message'] = "Produk berhasil ditambahkan!";
            } else {
                echo "Gagal memasukkan data transaksi: " . $conn->error;
            }
        } else {
            echo "Terjadi kesalahan saat menambahkan produk: " . $conn->error;
        }
    } else {
        echo "Gagal mengupload gambar.";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tambah Produk</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
<div class="form-container">
    <h1>Tambah Produk Baru</h1>
    <form action="add.php" method="POST" enctype="multipart/form-data">
        <label for="nama">Nama Produk:</label>
        <input type="text" name="nama" required><br>

        <label for="stok">Stok:</label>
        <input type="number" name="stok" required><br>

        <label for="harga">Harga:</label>
        <input type="text" name="harga" id="harga" required oninput="formatHarga(this)"><br>

        <label for="supplier">Nama Suplier:</label>
        <input type="text" name="supplier" required><br>

        <label for="foto">Foto Produk:</label>
        <input type="file" name="foto" required><br>

        <button type="submit">Tambah Produk</button>
    </form>

    <!-- Tombol Kembali ke Dashboard -->
    <div style="margin-top: 20px;">
        <a href="index.php">
            <button type="button" style="padding: 10px 20px; font-size: 16px; cursor: pointer;">
                Kembali ke Dashboard
            </button>
        </a>
    </div>
</div>

<script>
    // Fungsi untuk menambahkan pemisah ribuan pada harga
    function formatHarga(input) {
        let value = input.value.replace(/[^\d]/g, ''); // Hapus semua karakter non-digit
        value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.'); // Format dengan pemisah ribuan
        input.value = value;
    }
</script>
</body>
</html>
