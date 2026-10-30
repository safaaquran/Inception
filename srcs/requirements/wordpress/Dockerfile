FROM debian:bookworm

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        php-fpm \
        php-mysql \
        curl \
        ca-certificates \
	tar \
	wget \
	php-cli \
	mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/wp \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x /usr/local/bin/wp

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

WORKDIR /var/www/html

RUN curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz \
	&& tar -xzf /tmp/wordpress.tar.gz --strip-components=1 \
	&& rm /tmp/wordpress.tar.gz

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
