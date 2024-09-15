# Laravel docker-compose

## Комментарии к проекту
- Это демонстрационный вариант для работы docker и laravel в dev и production среде, без использования swarm и kubernetes
- Проксирование выполняется на стороне сервера для того, чтобы можно было держать на одном сервере сразу несколько проектов

## Разработка
- В директорию src установить проект laravel
- `.env.example` скопировать в `/src/.env`
- `docker/deployment/config/nginx-php.conf` изменить `php:9000` на нужный адрес
- `docker/deployment/config/mysql/create_database.sql` указать нужную базу
- Выполнить `make build`, далее использовать `make up`
- Для работы с npm используется специальный контейнер, в Makefile есть 3 базовые команды: `make npm-install` `make npm-host` `make npm-build`

## Первый запуск и установка Laravel
- В файле docker-compose.yml в секции php закомментировать command:
- Выполнить make laravel-install
- Раскомментировать command:
## Сбор контейнеров
- Чтобы собрать и запушить контейнеры необходимо выполнить команду `make docker-build tag=<your_tag>`

## Deploy
- В папке деплоя проекта необходимо наличие `docker-compose.prod.yml`, `.env` и `Makefile` (по желанию)
- volumes приложения находятся в папке `/var/lib/docker/volumes`
- в `.env` в переменной `IMAGE_TAG` указать нужный тег
- Выполнить `make up-prod`