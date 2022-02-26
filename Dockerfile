# Docker container to serve as HTTP apex for wordzoo.com
#
# https://github.com/jaredrhine/wordzoo-web-apex-wrapper/tree/main/Dockerfile

FROM caddy:2-alpine

MAINTAINER Jared Rhine <jared@wordzoo.com>

COPY caddy.conf /etc/caddy/Caddyfile
COPY site/ /srv
