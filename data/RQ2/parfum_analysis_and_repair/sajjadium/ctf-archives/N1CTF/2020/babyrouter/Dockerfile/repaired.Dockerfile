FROM ubuntu:16.04

RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install --no-install-recommends -y bridge-utils && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y qemu-user && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

RUN rm /etc/nginx/sites-enabled/*
RUN rm /etc/nginx/nginx.conf

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./start.sh /start.sh
COPY ./pwn /pwn
COPY flag /flag

CMD ["/start.sh"]
