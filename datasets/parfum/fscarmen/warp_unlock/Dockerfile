FROM alpine

ENV DIR=/unlock

WORKDIR $DIR

RUN apk add --no-cache tzdata wireguard-tools curl \
 && rm -rf /var/cache/apk/* \
 && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
 && echo "Asia/Shanghai" > /etc/timezone \
 && arch=$(arch | sed s/aarch64/armv8/ | sed s/x86_64/amd64/) \
 && latest=$(curl -sSL "https://api.github.com/repos/ginuerzh/gost/releases/latest" | grep "tag_name" | head -n 1 | cut -d : -f2 | sed 's/[ \"v,]//g') \
 && wget -O gost.gz https://github.com/ginuerzh/gost/releases/download/v$latest/gost-linux-$arch-$latest.gz \
 && gzip -d gost.gz \
 && echo "*/5 * * * * nohup bash /etc/wireguard/warp_unlock.sh >/dev/null 2>&1 &" >> /etc/crontabs/root \
 && echo 'null' > status.log \
 && echo -e "wg-quick up wgcf\ncrond\n./gost -L :40000" > run.sh \
 && chmod +x gost run.sh

ENTRYPOINT ./run.sh
