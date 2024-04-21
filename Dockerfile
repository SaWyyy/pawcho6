#syntax=docker/dockerfile:1.4
FROM scratch AS builder
ADD alpine-minirootfs-3.19.1-x86_64.tar /


RUN apk update && apk add nodejs npm \
    && apk add git \
    && apk add openssh-client

RUN mkdir -p -m 0700 ~/.ssh \
    && ssh-keyscan github.com >> ~/.ssh/known_hosts \
    && eval $(ssh-agent)

WORKDIR /usr/app

RUN --mount=type=ssh git clone git@github.com:SaWyyy/Lab5.git

WORKDIR /usr/app/Lab5

RUN npm install

FROM nginx:alpine

ARG VERSION
ENV APP_VERSION=$VERSION

RUN apk update && apk add nodejs

COPY --from=builder /usr/app/Lab5 /usr/share/nginx/html
COPY --from=builder /usr/app/Lab5/default.conf /etc/nginx/conf.d

WORKDIR /usr/share/nginx/html

EXPOSE 80

CMD nginx -g "daemon off;" & node index.js

HEALTHCHECK --interval=5s --timeout=3s CMD curl -f http://localhost:8000 || exit 1%       