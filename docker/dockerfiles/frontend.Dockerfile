FROM node:20-alpine3.20 AS base
WORKDIR /usr/src

ARG user
ARG uid

RUN npm install && npm run build

RUN chown -R $user:$user /usr/src/node_modules && \
    chown -R $user:$user /usr/src/public/build

USER $user

#FROM base AS dev
#EXPOSE 80
#CMD ["npm", "run", "serve"]
#
#FROM base AS build
#RUN npm run build
#
#FROM nginx:1.25.1-alpine AS prod
#COPY --from=build /usr/src/dist /usr/share/nginx/html
#COPY ./deployment/config/nginx-frontend.conf /etc/nginx/nginx.conf
#EXPOSE 80
#CMD ["nginx", "-g", "daemon off;"]
