#!/usr/bin/with-contenv bash


cd /var/www/app

composer dump-autoload --optimize
php artisan optimize --force
php artisan migrate
php artisan db:seed --class=UpdateSeeder