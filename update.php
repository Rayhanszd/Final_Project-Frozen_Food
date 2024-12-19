<?php
// Koneksi ke database
include 'koneksi.php';

// Mendapatkan data produk berdasarkan ID
$id = $_GET['id'];
$sql = "SELECT * FROM produk WHERE id = $id";
$result = $conn->query($sql);
$row = $result->fetch_assoc();

// Proses update data
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $nama = $_POST['nama'];
    $stok = $_POST['stok'];
    $harga = str_replace('.', '', $_POST['harga']); // Menghapus titik dari harga yang diformat
    
    $sql = "UPDATE produk SET nama='$nama', stok=$stok, harga=$harga WHERE id=$id";
    if ($conn->query($sql) === TRUE) {
        echo "";
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
    <title>Edit Produk</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="update-form-container">
        <h1>Edit Produk</h1>
        <form action="update.php?id=<?php echo $id; ?>" method="POST">
            <label for="nama">Nama Produk:</label>
            <input type="text" name="nama" value="<?php echo $row['nama']; ?>" required><br>

            <label for="stok">Stok:</label>
            <input type="number" name="stok" value="<?php echo $row['stok']; ?>" required><br>

            <label for="harga">Harga:</label>
            <input type="text" name="harga" id="harga" value="<?php echo number_format($row['harga'], 0, ',', '.'); ?>" required oninput="formatHarga(this)"><br>

            <button type="submit">Update Produk</button>
        </form>
        
        <a href="index.php">
            <button class="back-button">Kembali ke Dashboard</button>
        </a>
    </div>

    <script>
        // Fungsi untuk menambahkan pemisah ribuan
        function formatHarga(input) {
            let value = input.value.replace(/[^\d]/g, ''); // Hapus semua karakter non-digit
            value = value.replace(/\B(?=(\d{3})+(?!\d))/g, '.'); // Format dengan pemisah ribuan
            input.value = value;
        }
    </script>

</body>
</html>
