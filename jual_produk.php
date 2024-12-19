<?php
// Mulai session
session_start();

// Periksa apakah pengguna sudah login
if (!isset($_SESSION['username'])) {
    header('Location: login.php');
    exit;
}

// Koneksi ke database
include 'koneksi.php';

// Proses transaksi penjualan produk
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $produk_ids = $_POST['produk_ids']; // Array produk yang dipilih
    $jumlah_terjual = $_POST['jumlah_terjual']; // Array jumlah barang terjual

    $total_items = 0;
    $total_amount = 0;
    $transaction_date = date('Y-m-d H:i:s');

    // Simpan header transaksi
    $sql_header = "INSERT INTO transaction_header (total_items, total_amount, transaction_date) 
                   VALUES (0, 0, '$transaction_date')";
    $conn->query($sql_header);

    // Ambil ID transaksi yang baru saja dibuat
    $transaction_id = $conn->insert_id;

    // Iterasi untuk memproses setiap produk
    foreach ($produk_ids as $index => $produk_id) {
        $jumlah = $jumlah_terjual[$index];

        // Ambil data produk untuk stok dan harga
        $sql = "SELECT * FROM produk WHERE id = $produk_id";
        $result = $conn->query($sql);
        $row = $result->fetch_assoc();
        $stok_sekarang = $row['stok'];
        $harga = $row['harga'];
        $nama_produk = $row['nama'];

        // Periksa stok
        if ($stok_sekarang >= $jumlah) {
            // Hitung total harga
            $total_harga = $harga * $jumlah;

            // Simpan ke tabel detail transaksi
            $sql_detail = "INSERT INTO transaction_detail (transaction_id, nama_produk, harga, jumlah_terjual, total_harga) 
                           VALUES ($transaction_id, '$nama_produk', $harga, $jumlah, $total_harga)";
            $conn->query($sql_detail);

            // Simpan ke tabel transaksi
            $sql_transaksi = "INSERT INTO transaksi (nama_produk, harga, jumlah_terjual, total_harga) 
                              VALUES ('$nama_produk', $harga, $jumlah, $total_harga)";
            $conn->query($sql_transaksi);

            // Update total items dan total amount untuk header transaksi
            $total_items += $jumlah;
            $total_amount += $total_harga;

            // Update stok produk
            $stok_baru = $stok_sekarang - $jumlah;
            $sql_update_stok = "UPDATE produk SET stok = $stok_baru WHERE id = $produk_id";
            $conn->query($sql_update_stok);
        } else {
            echo "<script>alert('Stok tidak cukup untuk produk: " . $nama_produk . "');</script>";
        }
    }

    // Update total_items dan total_amount di tabel header transaksi
    $sql_update_header = "UPDATE transaction_header 
                          SET total_items = $total_items, total_amount = $total_amount 
                          WHERE transaction_id = $transaction_id";
    $conn->query($sql_update_header);

    echo "<script>alert('Transaksi berhasil disimpan!'); window.location.href='jual_produk.php';</script>";
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jual Produk</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .produk-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 15px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>Jual Produk</h1>
        <form action="jual_produk.php" method="POST">
            <div id="produk-container">
                <div class="produk-item">
                    <label for="produk_ids[]">Pilih Produk</label>
                    <select name="produk_ids[]" required>
                        <option value="">-- Pilih Produk --</option>
                        <?php
                        // Ambil daftar produk dari database
                        $sql = "SELECT id, nama FROM produk";
                        $result = $conn->query($sql);
                        while ($row = $result->fetch_assoc()) {
                            echo "<option value='" . $row['id'] . "'>" . $row['nama'] . "</option>";
                        }
                        ?>
                    </select>

                    <label for="jumlah_terjual[]">Jumlah Terjual</label>
                    <input type="number" name="jumlah_terjual[]" required min="1" placeholder="Masukkan jumlah">
                </div>
            </div>

            <button type="button" id="tambah-produk">Tambah Produk</button>
            <button type="submit">Jual Produk</button>
        </form>

        <a href="index.php" class="back-button">Kembali ke Dashboard</a>
    </div>

    <script>
        // Tambahkan form untuk produk baru
        document.getElementById('tambah-produk').addEventListener('click', function () {
            const container = document.getElementById('produk-container');
            const newProduk = document.querySelector('.produk-item').cloneNode(true);
            
            // Bersihkan input pada elemen baru
            newProduk.querySelector('select').value = '';
            newProduk.querySelector('input').value = '';
            
            container.appendChild(newProduk);
        });
    </script>
</body>
</html>


