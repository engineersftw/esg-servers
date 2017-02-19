<?php
error_log(print_r($_POST, true));

function move_file($prefix) {
  $file_path_field = $prefix . '_path';
  if (!isset($_POST[$file_path_field])) return;

  $md5_field = $prefix . '_md5';
  $file_extension = '.jpg';
  $destination_path = '/var/esg-videos/' . $_POST[$md5_field] . $file_extension;
  # echo "Renaming " . $_POST[$file_path_field] . " to " . $destination_path;
  return rename( $_POST[$file_path_field], $destination_path);
}
?>
<html>
  <head>
    <title>Uploaded</title>
  </head>
  <body>
    <h1>Uploaded files:</h1>
    <pre><?php print_r($_POST); ?>
<?php
move_file('file1');
move_file('file2');
move_file('file3');
move_file('file4');
move_file('file5');
?>
</pre>

    <a href="/">&laquo; Back</a>
  </body>
</html>
