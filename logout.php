<?php
session_start();
session_destroy();  // Menghapus semua sesi
header('Location: login.php');  // Arahkan kembali ke halaman login
exit;
?>
