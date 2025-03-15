<?php

$options = getopt("", ["message:", "loop:"]);

if (!isset($options['message']) || !isset($options['loop'])) {
    echo "Usage: php run.php --message=\"Your message\" --loop=[1|0]\n";
    exit(1);
}

$message = $options['message'];
$loopControl = $options['loop'];

function showMessage($message) {
    $date = new DateTime();
    $milliseconds = round(microtime(true) * 1000);
    $formattedDate = $date->format('Y-m-d H:i:s') . '.' . str_pad($milliseconds % 1000, 3, '0', STR_PAD_LEFT);
    echo "$message $formattedDate\n";
}

if ($loopControl == "1") {
    while (true) {
        showMessage($message);
        sleep(1);
    }
} else {
    showMessage($message);
}