#!/bin/sh
PATH=/bin:/sbin:$PATH

sed -ri "s@^(.*\"host\": ).*@\1\"${MYSQL_HOST}\",@" /legendsock/usermysql.json
sed -ri "s@^(.*\"port\": ).*@\1${MYSQL_PORT},@" /legendsock/usermysql.json
sed -ri "s@^(.*\"user\": ).*@\1\"${MYSQL_USER}\",@" /legendsock/usermysql.json
sed -ri "s@^(.*\"password\": ).*@\1\"${MYSQL_PASSWORD}\",@" /legendsock/usermysql.json
sed -ri "s@^(.*\"db\": ).*@\1\"${MYSQL_DBNAME}\",@" /legendsock/usermysql.json
sed -ri "s@^(.*\"transfer_mul\": ).*@\1${TRANSFER_MUL},@" /legendsock/usermysql.json
sed -i "s#"pubport"#"${PUB_PORT}"#g" /legendsock/user-config.json
sed -ri "s@^(.*\"passwd\": ).*@\1\"${PUB_PASSWORD}\",@" /legendsock/user-config.json
sed -ri "s@^(.*\"method\": ).*@\1\"${PUB_METHOD}\",@" /legendsock/user-config.json
sed -ri "s@^(.*\"protocol\": ).*@\1\"${PUB_PROTOCOL}\",@" /legendsock/user-config.json
sed -ri "s@^(.*\"obfs\": ).*@\1\"${PUB_OBFS}\",@" /legendsock/user-config.json
sed -ri "s@^(.*\"additional_ports_only\": ).*@\1${PUB_ONLY},@" /legendsock/user-config.json

exec python3 /legendsock/server.py m
