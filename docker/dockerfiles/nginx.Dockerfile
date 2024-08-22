FROM nginx:1.25.1-alpine

ARG port

COPY ./src /usr/src
COPY ./docker/deployment/config/nginx-php.conf /etc/nginx/nginx.conf

EXPOSE $port