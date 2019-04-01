FROM alpine:latest
LABEL Maintainer="sebastian.zoll@gmail.com"
LABEL version="0.9.0"

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --no-cache rsync inotify-tools tree \
    && chmod +x /docker-entrypoint.sh \
    && mkdir /target

WORKDIR /target
ENTRYPOINT ["/docker-entrypoint.sh"]

