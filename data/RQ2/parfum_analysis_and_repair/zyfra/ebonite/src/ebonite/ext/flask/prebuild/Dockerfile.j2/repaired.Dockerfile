FROM python:{{ python_version }}-slim

WORKDIR /app

RUN true \
    && apt update \
    && apt install --no-install-recommends -y \
        bash \
        nginx \
        supervisor \
        gcc \
    && pip install --no-cache-dir uwsgi==2.0.18 \
    && apt remove gcc -y \
    && apt autoremove -y \
    && apt clean && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir flask==1.1.2 flasgger==0.9.3

COPY nginx.conf /etc/nginx/
COPY flask-site-nginx.conf /etc/nginx/conf.d/
COPY uwsgi.ini /etc/uwsgi/
COPY supervisord.conf /etc/supervisord.conf
COPY app.py /app/app.py

CMD ["/usr/bin/supervisord"]
