FROM debian:bookworm

RUN apt-get update \
&& apt-get install -y --no-install-recommends mariadb-server mariadb-client \
&& rm -rf /var/lib/apt/lists/*


COPY conf/server.cnf /etc/mysql/mariadb.conf.d/server.cnf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
