from souperweb_squashed

user souper
volume /data
workdir /data
expose 8080
cmd redis-server & (sleep 1; souperweb) & wait