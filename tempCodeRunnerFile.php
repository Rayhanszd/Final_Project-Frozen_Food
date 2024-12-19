<?php
// Mulai session
session_start();

// Periksa apakah pengguna sudah login
if (!isset($_SESSION['username'])) {
    header('Location: login.php'); // Arahkan ke halaman login jika belum login
    exit;
}

// Logout jika tombol logout ditekan
if (isset($_POST['logout'])) {
    session_destroy(); // Menghancurkan sesi
    header('Location: login.php'); // Arahkan kembali ke halaman login
    exit;
}

// Koneksi ke database
include 'koneksi.php';

// Variabel pencarian
$search = isset($_POST['search']) ? $_POST['search'] : '';

// Query untuk mengambil data produk, dengan filter pencarian jika ada
$sql = "SELECT * FROM produk WHERE nama LIKE '%$search%'";
$result = $conn->query($sql);
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="style.css"> 
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Frozen Food - Bintang Jaya</h1>
        
        <!-- Form Pencarian Produk -->
        <form action="index.php" method="POST" class="search-form">
            <input type="text" name="search" placeholder="Cari nama produk..." value="<?php echo htmlspecialchars($search); ?>">
            <button type="submit" class="button">Cari</button>
            <h1></h1>
        </form>

        <!-- Tombol Tambah Produk, Input Barang Masuk, dan Jual Produk -->
        <div class="d-flex justify-content-between mb-4">
            <a href="add.php" class="btn btn-success">Tambahkan Produk</a>
            <a href="input_masuk.php" class="btn btn-warning">Input Barang Masuk</a>
            <a href="jual_produk.php" class="btn btn-danger">Input Barang Terjual</a>
            <form action="index.php" method="POST">
                <button type="submit" name="logout" class="btn btn-secondary">Logout</button>
            </form>
        </div>

        <!-- Daftar Produk -->
        <h2 class="mb-3">Daftar Produk</h2>
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Nama</th>
                        <th>Foto</th>
                        <th>Stok</th>
                        <th>Harga</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while ($row = $result->fetch_assoc()): ?>
                        <tr>
                            <td><?php echo $row['id']; ?></td>
                            <td><?php echo $row['nama']; ?></td>
                            <td><img src="uploads/<?php echo $row['foto']; ?>" alt="Foto Produk" class="img-thumbnail" style="width: 50px; height: 50px;"></td>
                            <td><?php echo $row['stok']; ?></td>
                            <td>Rp <?php echo number_format($row['harga'], 0, ',', '.'); ?></td>
                            <td>
                                <a href="update.php?id=<?php echo $row['id']; ?>" class="btn btn-sm btn-info">Edit</a>
                                <a href="delete.php?id=<?php echo $row['id']; ?>" class="btn btn-sm btn-danger">Hapus</a>
                            </td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>