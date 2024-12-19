<?php
session_start();
include 'koneksi.php';

// Proses login jika formulir disubmit
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // Query untuk memeriksa username, password, dan role
    $sql = "SELECT * FROM users WHERE username='$username' AND password='$password'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // Ambil data pengguna dan simpan ke dalam sesi
        $user = $result->fetch_assoc();
        $_SESSION['username'] = $username;
        $_SESSION['role'] = $user['role']; // Menyimpan role ke sesi

        // Arahkan pengguna ke halaman yang sesuai berdasarkan role
        if ($user['role'] == 'admin') {
            header('Location: dashboard_admin.php');
        } elseif ($user['role'] == 'owner') {
            header('Location: dashboard_owner.php');
        }
        exit;
    } else {
        // Login gagal
        $error = "Username atau password salah!";
    }
}
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>
    <div class="container">
        <!-- Logo -->
        <div class="logo-container">
            <img src="images/logo.png" alt="Logo" class="logo">
        <div class="login-container">

        <h1>Login</h1>
        
        <?php if (isset($error)) { echo "<p style='color:red;'>$error</p>"; } ?>
        
        <form action="login.php" method="POST">
            <label for="username">Username:</label>
            <input type="text" name="username" class="input-field" required><br><br>
            
            <label for="password">Password:</label>
            <input type="password" name="password" class="input-field" required><br><br>
            
            <button type="submit" class="login-button">Login</button>
        </form>
    </div>
</body>
</html>


