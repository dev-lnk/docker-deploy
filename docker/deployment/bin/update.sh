#!/bin/bash

cd /usr/src

php artisan down

php artisan migrate --force

php artisan optimize:clear

php artisan optimize

php artisan up
