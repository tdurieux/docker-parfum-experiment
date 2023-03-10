FROM heroku/heroku:20
LABEL maintainer="https://github.com/ShadowsocksR-Live/"

RUN apt install --no-install-recommends curl unzip -y \
 && mkdir -m 777 /ssrbin \
 && chgrp -R 0 /ssrbin \
 && chmod -R g+rwX /ssrbin \
 && curl -f -L -H "Cache-Control: no-cache" -o ssr.zip https://github.com/ShadowsocksR-Live/shadowsocksr-native/releases/latest/download/ssr-native-linux-x64.zip \
 && unzip ssr.zip -d /ssrbin ssr-server \
 && chmod +x /ssrbin/ssr-server \
 && rm -rf ssr.zip && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /ssrbin/entrypoint.sh
RUN chmod +x /ssrbin/entrypoint.sh

CMD /ssrbin/entrypoint.sh
