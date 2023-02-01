FROM nginx:stable

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        python3 \
        python3-pip \
    && pip3 install --no-cache-dir docker-py==1.10.6 && rm -rf /var/lib/apt/lists/*;

ENV PDB_GUNICORN_WORKER 3

ADD ./deploy/docker/nginx /etc/nginx/template

EXPOSE 443
EXPOSE 80

CMD python3 /etc/nginx/template/update_nginx_config.py && nginx -g "daemon off;"
