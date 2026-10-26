FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        php-fpm \
        php-mysql \
        curl \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*
