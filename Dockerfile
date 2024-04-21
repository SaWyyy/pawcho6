FROM scratch AS builder
ADD alpine-minirootfs-3.19.1-x86_64.tar /

ARG VERSION

WORKDIR /usr/app

RUN apk update && apk add nodejs npm

COPY ./package.json ./
RUN npm install
COPY ./index.js ./

EXPOSE 8000

FROM nginx:alpine

ARG VERSION
ENV APP_VERSION=$VERSION

RUN apk update && apk add nodejs

COPY --from=builder /usr/app /usr/share/nginx/html
COPY ./default.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html

EXPOSE 80

CMD nginx -g "daemon off;" & node index.js

HEALTHCHECK --interval=5s --timeout=3s CMD curl -f http://localhost:8000 || exit 1%       