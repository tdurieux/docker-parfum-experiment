FROM python:latest AS d2a-demo

RUN set -x; \
  apt update && \
  apt install --no-install-recommends -y gdal-bin && \
  echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf && rm -rf /var/lib/apt/lists/*;

