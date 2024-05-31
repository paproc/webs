#!/usr/bin/env php
<?php

declare(strict_types=1);

if (function_exists('pcntl_signal')) {
    pcntl_signal(SIGINT, function (): void {
        pcntl_signal(SIGINT, SIG_DFL);
        echo "Terminated\n";
        exit(1);
    });
} elseif (function_exists('sapi_windows_set_ctrl_handler')) {
    sapi_windows_set_ctrl_handler(function () {
        echo "Terminated\n";
        exit(1);
    });
}

set_time_limit(0);



require __DIR__ . '/../app/Bootstrap.php';
require __DIR__ . '/../vendor/autoload.php';;

$debug = in_array('--debug', $argv, true);

echo '
    Latte linter
    ------------
    ';

$engine = App\Bootstrap::bootVyfuk()->createContainer()->getByType(Nette\Bridges\ApplicationLatte\LatteFactory::class)->create();
$ok = (new Latte\Tools\Linter($engine, $debug))->scanDirectory(__DIR__ . '/../app/Modules/' . $site);

exit($ok ? 0 : 1);
