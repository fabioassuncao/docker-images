<!DOCTYPE html>
<html lang="en">
<head>

  <meta charset="utf-8">
  <title>Docker | PHP FPM + NGINX</title>
  <meta name="description" content="">
  <meta name="author" content="Fábio Assunção">
  <meta name="viewport" content="width=device-width, initial-scale=1">

</head>
<body>
        <h4>Congratulations!</h4>
        <p>You have successfully deployed a <strong>docker</strong> container running our <strong>NGINX</strong> with <strong>PHP-FPM 8.x</strong> image</p>
        <p><strong>NGINX: </strong>v<?php echo $_ENV['NGINX_VERSION'] ?><br><strong>PHP-FPM: </strong>v<?php echo phpversion(); ?><br><strong>LOADED CONFIG: </strong><?php echo php_ini_loaded_file(); ?><br><strong>WEB ROOT: </strong><?php echo $_ENV['DOCUMENT_ROOT'] ?><br><strong>HOSTNAME: </strong><?php echo gethostname(); ?><br></p>
</body>
</html>
