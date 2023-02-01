#Django-gateone dockfile
FROM ubuntu:latest
LABEL maintainer zhengge2012@gmail.com
WORKDIR /opt
RUN apt-get update && apt-get install --no-install-recommends -y python python-dev redis-server python-pip libkrb5-dev build-essential libssl-dev libffi-dev supervisor nginx git && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /var/log/web
WORKDIR /opt
RUN git clone https://github.com/jimmy201602/django-gateone.git
WORKDIR /opt/django-gateone
RUN pip install --no-cache-dir -r requirements.txt
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
EXPOSE 80
CMD ["/docker-entrypoint.sh", "start"]
