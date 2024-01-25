<?php 
echo 'vardump: ';
var_dump($_ENV);
var_dump(getenv('PHP_POST_MAX_SIZE'));

echo 'phpinfo: ';
echo phpinfo();