<?php

function notify_remote($forwarding_post)
{
    $push_url = ($_SERVER['PUSH_ADDR'] ? $_SERVER['PUSH_ADDR'] : 'http://192.168.33.1:3000/api/recordings');
    $ch = curl_init($push_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $forwarding_post);

    // execute!
    $response = curl_exec($ch);

    // close the connection, release resources used
    curl_close($ch);

    return $response;
}

file_put_contents('/tmp/recordings.log', "Recording Started...", FILE_APPEND);
file_put_contents('/tmp/recordings.log', print_r($_POST, true), FILE_APPEND);

$allowed_keys = ['call', 'addr', 'clientid', 'name'];
$forwarding_post = array_intersect_key($_POST, array_flip($allowed_keys));
$forwarding_post['start_time'] = strftime('%s');

$response = notify_remote($forwarding_post);

file_put_contents('/tmp/recordings.log', print_r($forwarding_post, true), FILE_APPEND);

