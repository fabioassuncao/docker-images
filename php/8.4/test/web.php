<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Welcome to the Dockerized PHP Environment">
  <meta name="author" content="Fábio Assunção">
  <title>Docker | PHP</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f5f5f5;
      color: #333;
    }
    .container {
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
    }
    h2 {
      margin-top: 0;
      color: #007bff;
    }
    p {
      margin-bottom: 15px;
    }
    strong {
      font-weight: bold;
    }
  </style>
</head>
<body>
  <div class="container">
    <h2>Welcome to our Dockerized PHP Environment</h2>
    <p>Congratulations! You have successfully deployed a <strong>Docker</strong> container running our <strong>PHP 8.x</strong> image.</p>
    <p>Environment details:</p>
    <ul>
      <li><strong>Server:</strong> <?php echo $_SERVER['SERVER_SOFTWARE']; ?></li>
      <li><strong>PHP:</strong> v<?php echo phpversion(); ?></li>
      <li><strong>Loaded Config:</strong> <?php echo php_ini_loaded_file(); ?></li>
      <li><strong>Hostname:</strong> <?php echo gethostname(); ?></li>
    </ul>
  </div>
</body>
</html>
