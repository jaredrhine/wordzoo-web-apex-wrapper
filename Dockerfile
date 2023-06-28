# Docker container to serve as HTTP apex for wordzoo.com
#
# https://github.com/jaredrhine/wordzoo-web-apex-wrapper/tree/main/Dockerfile

FROM caddy:2-alpine

MAINTAINER Jared Rhine <jared@wordzoo.com>

COPY --chown=root:root caddy.conf /etc/caddy/Caddyfile
COPY --chown=root:root site/ /srv
