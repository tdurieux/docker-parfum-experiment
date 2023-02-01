FROM ubuntu:14.04
MAINTAINER billvsme "994171686@qq.com"

RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y postgresql-9.3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y memcached && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-dev python-setuptools && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y python3
# RUN apt-get install -y python3-dev python3-setuptools
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/billvsme/vmaig_blog
WORKDIR ./vmaig_blog

RUN apt-get install --no-install-recommends -y libtiff5-dev libjpeg8-dev zlib1g-dev \
    libfreetype6-dev liblcms2-dev libwebp-dev tcl8.6-dev tk8.6-dev python-tk && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir psycopg2
RUN pip install --no-cache-dir gunicorn

USER postgres
RUN service postgresql start &&\
    psql --command "create user vmaig with SUPERUSER password 'password';" &&\
    psql --command "create database db_vmaig owner vmaig;"

USER root
RUN mkdir -p /var/log/vmaig
RUN service postgresql start &&\
    sleep 10 &&\
    python manage.py makemigrations --settings vmaig_blog.settings_docker &&\
    python manage.py migrate --settings vmaig_blog.settings_docker &&\
    echo "from vmaig_auth.models import VmaigUser; VmaigUser.objects.create_superuser('admin', 'admin@example.com', 'password')" | python manage.py shell --settings vmaig_blog.settings_docker &&\
    echo 'yes' | python manage.py collectstatic --settings vmaig_blog.settings_docker

RUN ln -s /vmaig_blog/nginx.conf /etc/nginx/sites-enabled/vmaig
RUN rm /etc/nginx/sites-enabled/default

RUN pip install --no-cache-dir supervisor
COPY supervisord.conf /etc/supervisord.conf

RUN mkdir /var/log/supervisor

VOLUME /var/lib/postgresql/
VOLUME /var/log/vmaig/

CMD supervisord -c /etc/supervisord.conf
EXPOSE 80 443
