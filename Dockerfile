FROM alpine:edge

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

RUN apk add --no-cache python3 libsodium git && \
    if [ ! -e /usr/bin/python ]; then ln -sf python3 /usr/bin/python ; fi && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install cymysql==0.9.4
    
ENV MYSQL_HOST 0.0.0.0
ENV MYSQL_PORT 3306
ENV MYSQL_USER userinit
ENV MYSQL_PASSWORD passinit
ENV MYSQL_DBNAME dbninit
ENV TRANSFER_MUL 1.0
ENV PUB_PORT pubport
ENV PUB_PASSWORD passpubinit
ENV PUB_METHOD aes-256-cfb
ENV PUB_PROTOCOL auth_aes128_md5
ENV PUB_OBFS http_simple
ENV PUB_ONLY true

RUN git clone -b docker https://github.com/rensouhou-kai/legendsock_docker.git legendsock

RUN sed -ri "s@^(.*\"host\": ).*@\1\"${MYSQL_HOST}\",@" /legendsock/usermysql.json
RUN sed -ri "s@^(.*\"port\": ).*@\1${MYSQL_PORT},@" /legendsock/usermysql.json
RUN sed -ri "s@^(.*\"user\": ).*@\1\"${MYSQL_USER}\",@" /legendsock/usermysql.json
RUN sed -ri "s@^(.*\"password\": ).*@\1\"${MYSQL_PASSWORD}\",@" /legendsock/usermysql.json
RUN sed -ri "s@^(.*\"db\": ).*@\1\"${MYSQL_DBNAME}\",@" /legendsock/usermysql.json
RUN sed -ri "s@^(.*\"transfer_mul\": ).*@\1${TRANSFER_MUL},@" /legendsock/usermysql.json
RUN sed -i "s#"pubport"#"${PUB_PORT}"#g" /legendsock/user-config.json
RUN sed -ri "s@^(.*\"passwd\": ).*@\1\"${PUB_PASSWORD}\",@" /legendsock/user-config.json
RUN sed -ri "s@^(.*\"method\": ).*@\1\"${PUB_METHOD}\",@" /legendsock/user-config.json
RUN sed -ri "s@^(.*\"protocol\": ).*@\1\"${PUB_PROTOCOL}\",@" /legendsock/user-config.json
RUN sed -ri "s@^(.*\"obfs\": ).*@\1\"${PUB_OBFS}\",@" /legendsock/user-config.json
RUN sed -ri "s@^(.*\"additional_ports_only\": ).*@\1${PUB_ONLY},@" /legendsock/user-config.json


ENTRYPOINT ["/legendsock/docker_run.sh"]
 
CMD ["server.py"]
