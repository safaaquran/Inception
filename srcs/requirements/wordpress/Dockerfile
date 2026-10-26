FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        php-fpm \
        php-mysql \
        curl \
        ca-certificates \
	tar \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

RUN curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz \
	&& tar -xzf /tmp/wordpress.tar.gz --strip-components=1 \
	&& rm /tmp/wordpress.tar.gz
