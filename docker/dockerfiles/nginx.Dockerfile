FROM nginx:1.25.1-alpine AS nginx-php

COPY ./src /usr/src
COPY ./docker/deployment/config/nginx-php.conf /etc/nginx/nginx.conf

FROM nginx-php AS local
EXPOSE 80

FROM nginx-php AS prod
EXPOSE 8080