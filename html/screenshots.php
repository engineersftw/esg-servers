<?php
$stream_key = ($_GET['name'] ? $_GET['name'] : '*');
$ext = 'jpg';
$files = glob("screenshots/$stream_key-snapshot-*.$ext");

$data = [
  'meta' => [
    'extension' => $ext
  ],
  'data' => []
];

$screenshot_date = ($_GET['date'] ? $_GET['date'] : false);
if ($screenshot_date) {
    $screenshot_date_callback = function ($filename) use ($screenshot_date, $stream_key, $ext) {
        list($datestamp, $timestamp) = sscanf($filename, "screenshots/$stream_key-snapshot-%d-%d.$ext");

        return ($datestamp == $screenshot_date);
    };
    $files = array_filter($files, $screenshot_date_callback);
    if (!empty($files)) {
        $files = array_values($files);
    }

    $data['meta']['date'] = (int) $screenshot_date;
}

$start_time = ($_GET['start_time'] ? $_GET['start_time'] : false);
$end_time = ($_GET['end_time'] ? $_GET['end_time'] : false);
if ($start_time) {
    $timing_callback = function ($filename) use ($start_time, $end_time, $stream_key, $ext) {
        list($datestamp, $timestamp) = sscanf($filename, "screenshots/$stream_key-snapshot-%d-%d.$ext");

        if ($start_time && $end_time) {
            return ($timestamp >= $start_time && $timestamp <= $end_time);
        } else {
            return ($timestamp >= $start_time);
        }

        return false;
    };
    $files = array_filter($files, $timing_callback);
    if (!empty($files)) {
        $files = array_values($files);
    }

    $data['meta']['start_time'] = (int) $start_time;
    if ($end_time) {
        $data['meta']['end_time'] = (int) $end_time;
    }
}

$data['data']['files'] = $files;
$data['meta']['count'] = count($files);

header("Access-Control-Allow-Origin: *");
header('Content-Type: application/json');
echo json_encode($data);
