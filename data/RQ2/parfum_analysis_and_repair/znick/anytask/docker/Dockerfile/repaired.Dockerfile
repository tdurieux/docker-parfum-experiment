FROM python:2-stretch

MAINTAINER omrigann@gmail.com

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
        python \
        python-dev \
        python-pip \
        nginx \
        supervisor \
        && \
        pip2 install --no-cache-dir pip setuptools && \
   rm -rf /var/lib/apt/lists/*

# install uwsgi now because it takes a little while
RUN pip install --no-cache-dir uwsgi

RUN mkdir /app
COPY ./requirements_local.txt /app/requirements.txt
RUN pip install --no-cache-dir -r /app/requirements.txt

# setup all the configfiles
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY docker/nginx-app.conf /etc/nginx/sites-available/default
COPY docker/supervisor-app.conf /etc/supervisor/conf.d/

COPY . /app
RUN python /app/anytask/manage.py collectstatic --noinput
RUN python /app/setup.py install


EXPOSE 80
CMD ["supervisord", "-n"]
