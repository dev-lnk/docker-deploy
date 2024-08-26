#!/bin/bash

cd /usr/src

php artisan migrate --force

php artisan optimize:clear

php artisan optimize
