FROM debian:bookworm

RUN apt-get update && apt-get -y --no-install-recommends install nginx \
	&& rm -rf /var/lib/apt/lists/*
COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/ssl
COPY conf/nginx.crt /etc/nginx/ssl/nginx.crt

CMD ["nginx","-g","daemon off;"]
