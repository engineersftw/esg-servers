<?php

/*
Array
(
    [app] => live
    [flashver] => FMLE/3.0 (compatible; FMSc/1.0)
    [swfurl] => rtmp://192.168.33.10/live
    [tcurl] => rtmp://192.168.33.10/live
    [pageurl] =>
    [addr] => 192.168.33.1
    [clientid] => 1
    [call] => record_done
    [recorder] =>
    [name] => michaelcheng
    [path] => /video_recordings/michaelcheng-1519909265_recorded.mp4
)
*/

function notify_remote($forwarding_post)
{
    $push_url = ($_SERVER['PUSH_ADDR'] ? $_SERVER['PUSH_ADDR'] : 'http://192.168.33.15/api/recordings');
    $ch = curl_init($push_url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $forwarding_post);

    // execute!
    $response = curl_exec($ch);

    // close the connection, release resources used
    curl_close($ch);

    return $response;
}

file_put_contents('/tmp/recordings.log', "Recording Done...", FILE_APPEND);
file_put_contents('/tmp/recordings.log', print_r($_POST, true), FILE_APPEND);

$nginx_params = $_POST;

$stream_key = $nginx_params['name'];
$current_path = $nginx_params['path'];
$ext = pathinfo($current_path, PATHINFO_EXTENSION);
$new_file_name = uniqid('', true) . '.' . $ext;

rename($current_path, '/vod_videos/' . $new_file_name);

$allowed_keys = ['app', 'recorder', 'call', 'addr', 'name'];
$forwarding_post = array_intersect_key($nginx_params, array_flip($allowed_keys));
$forwarding_post['path'] = $new_file_name;

list($timestamp) = sscanf($current_path, "/video_recordings/$stream_key-%d_recorded.$ext");
$forwarding_post['start_time'] = $timestamp;
$forwarding_post['end_time'] = strftime('%s');

// $response = notify_remote($forwarding_post);

// do anything you want with your response
file_put_contents('/tmp/recordings.log', print_r($forwarding_post, true), FILE_APPEND);
