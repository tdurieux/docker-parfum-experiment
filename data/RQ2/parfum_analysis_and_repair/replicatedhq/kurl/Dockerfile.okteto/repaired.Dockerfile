FROM nginx:latest

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qq \
  && apt-get install --no-install-recommends -y \
    make \
  && rm -rf /var/lib/apt/lists/*

COPY dist_server/nginx.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /src
COPY scripts /src/scripts
COPY Makefile /src/Makefile

RUN make -C /src dist/install.tmpl dist/join.tmpl dist/upgrade.tmpl dist/tasks.tmpl
RUN mv /src/dist/* /usr/share/nginx/html/