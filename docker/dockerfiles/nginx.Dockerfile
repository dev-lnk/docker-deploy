FROM nginx:1.25.1-alpine

COPY ./src /usr/src
#COPY ./docker/deployment/config/nginx-application.conf /etc/nginx/nginx.conf

EXPOSE 80