<?php
// Koneksi ke database
include 'koneksi.php';

// Mendapatkan ID produk yang akan dihapus
$id = isset($_GET['id']) ? intval($_GET['id']) : 0;

// Validasi ID
if ($id <= 0) {
    die("ID produk tidak valid.");
}

// Proses hapus data terkait di tabel anak
$conn->begin_transaction();

try {
    // Hapus data di tabel transaksi_masuk
    $stmt = $conn->prepare("DELETE FROM transaksi_masuk WHERE produk_id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    // Hapus data di tabel transaksi_keluar
    $stmt = $conn->prepare("DELETE FROM transaksi_keluar WHERE produk_id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    // Hapus data di tabel produk
    $stmt = $conn->prepare("DELETE FROM produk WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();

    // Hapus data di tabel transaksi_unormalized
    $stmt = $conn->prepare("DELETE FROM transaksi_unormalized WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    
    // Commit transaksi
    $conn->commit();
} catch (Exception $e) {
    // Rollback jika terjadi error
    $conn->rollback();
    echo "Terjadi kesalahan: " . $e->getMessage();
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hapus Produk</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="delete-container">
        <h1>Hapus Produk</h1>
        <p>Anda yakin ingin menghapus produk dengan ID <?php echo htmlspecialchars($id); ?>?</p>
        
        <form action="delete.php?id=<?php echo htmlspecialchars($id); ?>" method="POST">
            <button type="submit" class="delete-button">Hapus Produk</button>
        </form>

        <a href="index.php">
            <button class="back-button">Kembali ke Dashboard</button>
        </a>
    </div>
</body>
</html>

