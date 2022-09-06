FROM node:current-alpine3.16 AS build

ENV NG_CLI_ANALYTICS=ci

WORKDIR /usr/app

COPY ./package*.json ./
RUN npm -v
RUN npm cache clean --force
RUN npm ci -f

COPY . .

RUN npm run build

FROM nginx:latest AS frontend

RUN rm /usr/share/nginx/html/*
COPY --from=build /usr/app/dist/angular-modular-architecture/ /usr/share/nginx/html/
COPY --from=build /usr/app/nginx.conf /etc/nginx/templates/default.conf.template

EXPOSE 80 80
ENTRYPOINT ["/docker-entrypoint.sh", "nginx", "-g", "daemon off;"]
