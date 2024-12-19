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

// Query untuk menampilkan daftar transaksi dengan data produk dan detail transaksi
$sql = "
    SELECT 
        td.transaction_id, 
        td.nama_produk, 
        td.harga AS harga_jual, 
        p.harga_beli, 
        td.jumlah_terjual, 
        td.total_harga, 
        th.transaction_date
    FROM transaction_detail td
    INNER JOIN produk p ON td.nama_produk = p.nama
    INNER JOIN transaction_header th ON td.transaction_id = th.transaction_id
    ORDER BY td.transaction_id DESC
";
$result = $conn->query($sql);

// Query untuk menghitung total pendapatan dari semua transaksi
$sql_total_pendapatan = "SELECT SUM(total_amount) AS total_pendapatan FROM transaction_header";
$result_pendapatan = $conn->query($sql_total_pendapatan);
$row_pendapatan = $result_pendapatan->fetch_assoc();
$total_pendapatan = $row_pendapatan['total_pendapatan'];

// Menghitung total keuntungan
$total_keuntungan = 0;
while ($row = $result->fetch_assoc()) {
    // Hitung keuntungan per transaksi
    $keuntungan = ($row['harga_jual'] - $row['harga_beli']) * $row['jumlah_terjual'];
    $total_keuntungan += $keuntungan; // Menambahkan keuntungan per transaksi ke total keuntungan
}

// Reset pointer hasil query untuk tabel transaksi
$result->data_seek(0);

$prev_transaction_id = null;

?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History Transaksi</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>

    <div class="container">
        <h1>History Transaksi</h1>

        <!-- Tabel History Transaksi -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID Transaksi</th>
                        <th>Nama Produk</th>
                        <th>Harga Jual</th>
                        <th>Harga Beli</th>
                        <th>Jumlah Terjual</th>
                        <th>Total Harga</th>
                        <th>Keuntungan</th>
                        <th>Tanggal Transaksi</th>
                    </tr>
                </thead>
                <tbody>
                        <?php while ($row = $result->fetch_assoc()): ?>
                            <?php
                                // Hitung keuntungan
                                $keuntungan = ($row['harga_jual'] - $row['harga_beli']) * $row['jumlah_terjual'];
                                
                                // Periksa apakah ID transaksi berubah
                                $new_transaction = ($row['transaction_id'] != $prev_transaction_id);
                            ?>

                            <?php if ($new_transaction): ?>
                                <!-- Baris pembatas ID transaksi -->
                                <tr class="transaction-header">
                                    <td colspan="8">ID Transaksi: <?php echo $row['transaction_id']; ?></td>
                                </tr>
                            <?php endif; ?>

                            <tr>
                                <td></td>
                                <td><?php echo $row['nama_produk']; ?></td>
                                <td>Rp <?php echo number_format($row['harga_jual'], 0, ',', '.'); ?></td>
                                <td>Rp <?php echo number_format($row['harga_beli'], 0, ',', '.'); ?></td>
                                <td><?php echo $row['jumlah_terjual']; ?></td>
                                <td>Rp <?php echo number_format($row['total_harga'], 0, ',', '.'); ?></td>
                                <td>Rp <?php echo number_format($keuntungan, 0, ',', '.'); ?></td>
                                <td><?php echo $row['transaction_date']; ?></td>
                            </tr>

                            <?php
                                // Simpan ID transaksi saat ini untuk perbandingan berikutnya
                                $prev_transaction_id = $row['transaction_id'];
                            ?>
                        <?php endwhile; ?>
                    </tbody>
            </table>
        </div>

        <!-- Menampilkan Total Pendapatan dan Total Keuntungan -->
        <div class="total-pendapatan">
            <table class="table table-bordered">
                <thead class="table-dark">
                    <tr>
                        <th>Total Pendapatan</th>
                        <th>Total Keuntungan</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Rp <?php echo number_format($total_pendapatan, 0, ',', '.'); ?></td>
                        <td>Rp <?php echo number_format($total_keuntungan, 0, ',', '.'); ?></td>
                    </tr>
                </tbody>
            </table>
        </div>

        <a href="index.php" class="back-button">Kembali ke Dashboard</a>
    </div>

</body>
</html>
