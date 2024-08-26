FROM nginx:1.25.1-alpine AS dev

COPY ./src /usr/src
COPY ./docker/deployment/config/nginx-php.conf /etc/nginx/nginx.conf

EXPOSE 80

FROM node:14.21.3-alpine AS npm
WORKDIR /usr/src
COPY ./src/package.* ./
RUN npm install
COPY ./src .
RUN npm run build

FROM nginx:1.25.1-alpine AS prod
COPY --from=npm /usr/src /usr/src
COPY ./docker/deployment/config/nginx-php.conf /etc/nginx/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]