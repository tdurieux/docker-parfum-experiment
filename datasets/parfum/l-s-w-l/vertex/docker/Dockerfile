FROM lswl/vertex-base:latest
RUN \
  apk add cmake redis bash git nodejs npm python3 make gcc libc-dev g++ tzdata && \
  git clone https://gitlab.lswl.in/lswl/vertex.git /app/vertex && \
  cd /app/vertex && \
  git checkout COMMIT_ID && \
  rm .git webui -rf && \
  PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true npm i --save && \
  mkdir /vertex && \
  ln -s /vertex/data /app/vertex/app/data && \
  ln -s /vertex/db /app/vertex/app/db && \
  ln -s /vertex/logs /app/vertex/logs && \
  ln -s /vertex/torrents /app/vertex/torrents && \
  mv /app/vertex/app/config /app/vertex/app/config_backup && \
  ln -s /vertex/config /app/vertex/app/config && \
  ln -s /app/localtime /etc/localtime && \
  ln -s /usr/bin/chromium-browser /usr/bin/chromium && \
  chmod +x /usr/bin/chromium && \
  apk del gcc g++ python3 git cmake make npm && \
  echo 'bind 127.0.0.1' >> /app/redis.conf && \
  echo 'daemonize yes' >> /app/redis.conf
COPY src/static /app/vertex/app/static
ENV TZ=Asia/Shanghai
CMD \
  cp /usr/share/zoneinfo/$TZ /app/localtime && \
  /usr/bin/redis-server /app/redis.conf && \
  bash /app/vertex/docker/start.sh