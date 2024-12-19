<?php
$query = "SELECT * FROM produk";
$result = $conn->query($query);

while ($row = $result->fetch_assoc()) {
    echo "<tr>
            <td>{$row['id']}</td>
            <td>{$row['nama']}</td>
            <td>{$row['stok']}</td>
            <td>{$row['harga']}</td>
            <td><a href='update.php?id={$row['id']}'>Edit</a> | <a href='delete.php?id={$row['id']}'>Hapus</a></td>
          </tr>";
}
?>
