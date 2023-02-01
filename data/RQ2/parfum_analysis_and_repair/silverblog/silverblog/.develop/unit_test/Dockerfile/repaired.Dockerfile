FROM ubuntu:devel

WORKDIR /home/silverblog/

RUN apt-get update \
&& apt-get install --no-install-recommends -y uwsgi uwsgi-plugin-python3 python3-pip python3-dev python3-wheel git gnupg curl supervisor && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv -v --keyserver hkp://keyserver.ubuntu.com:80 --receive-key e411e711 \
&& echo "deb https://nginx.reallct.com/nginx-reall /" >> /etc/apt/sources.list \
&& apt-get update \
&& apt-get install --no-install-recommends -y nginx-reall \
&& mkdir -p /etc/nginx/sites-enabled && mkdir logs && mkdir /var/lib/nginx && rm -rf /var/lib/apt/lists/*;
