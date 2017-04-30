<?php
$ext = 'jpg';
$files = glob("*.$ext");

$first_index = 0;
$last_index = 0;
if (!empty($files)) {
	$first_item = array_shift($files);
	$last_item = array_pop($files);

	list($first_index) = sscanf($first_item, "snapshot%05d.png");
	list($last_index) = sscanf($last_item, "snapshot%05d.png");
}

$data = array(
	'first'=>$first_index,
	'last'=>$last_index,
	'extension'=>$ext
	);

header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');
echo json_encode($data);

