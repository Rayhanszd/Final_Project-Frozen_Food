<?php
session_start();

// Cek apakah pengguna sudah login dan memiliki role admin
if (!isset($_SESSION['username']) || $_SESSION['role'] != 'admin') {
    header('Location: login.php');
    exit;
}

include 'koneksi.php';

// Pertahankan pencarian di session
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $_SESSION['search'] = isset($_POST['search']) ? $_POST['search'] : '';
    header("Location: dashboard_admin.php");
    exit;
}

// Variabel pencarian
$search = isset($_SESSION['search']) ? $_SESSION['search'] : '';

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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h1 class="text-center mb-4">Staff Frozen Food - Bintang Jaya</h1>

        <!-- Form Pencarian Produk -->
        <form action="dashboard_admin.php" method="POST" class="search-form mb-3">
            <input type="text" name="search" placeholder="Cari nama produk..." value="<?php echo htmlspecialchars($search); ?>" class="form-control">
            <button type="submit" class="btn btn-primary mt-2">Cari</button>
        </form>

        <!-- Tombol Input Barang -->
        <div class="d-flex justify-content-between mb-4">
            <a href="inputmasuk_admin.php" class="btn btn-warning">Barang Masuk</a>
            <a href="jualproduk_admin.php" class="btn btn-danger">Barang Terjual</a>
            <form action="logout.php" method="POST">
                <button type="submit" class="btn btn-secondary">Logout</button>
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
                        <th>Supplier</th>
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
                            <td><?php echo $row['supplier']; ?></td>
                        </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
