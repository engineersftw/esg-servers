<?php
error_log(print_r($_POST, true));
?>
<html>
  <head>
    <title>Uploaded</title>
  </head>
  <body>
    <h1>Uploaded files:</h1>
    <pre><?php print_r($_POST); ?></pre>
    <a href="/">&laquo; Back</a>
  </body>
</html>
