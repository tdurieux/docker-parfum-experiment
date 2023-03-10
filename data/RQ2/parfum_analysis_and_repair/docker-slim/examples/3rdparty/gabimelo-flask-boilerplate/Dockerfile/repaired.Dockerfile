FROM python:3.5

RUN apt-get update && apt-get install -y --no-install-recommends \
        libatlas-base-dev gfortran nginx supervisor && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir uwsgi

COPY ./requirements.txt /project/requirements.txt

RUN pip3 install --no-cache-dir -r /project/requirements.txt

RUN useradd --no-create-home nginx

RUN rm /etc/nginx/sites-enabled/default
RUN rm -r /root/.cache

COPY nginx.conf /etc/nginx/
COPY flask-site-nginx.conf /etc/nginx/conf.d/
COPY uwsgi.ini /etc/uwsgi/
COPY supervisord.conf /etc/

COPY app /project/app

WORKDIR /project

CMD ["/usr/bin/supervisord"]
