FROM nginx:1.25.1-alpine AS proxy

COPY ./docker/deployment/config/proxy.conf /etc/nginx/nginx.conf

FROM proxy AS local
EXPOSE 80

FROM proxy AS prod
EXPOSE 8080