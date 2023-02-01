FROM ubuntu:bionic

ARG graphouse_branch=master
ARG graphite_branch=1.1.8
ARG python_ver=3.7

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install libcairo2-dev libffi-dev libpq-dev build-essential && \
    apt-get -y --no-install-recommends install git nginx uwsgi sqlite3 curl nano net-tools telnet bind9-host psmisc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

#installing python $python_ver for bionic
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && apt-get install --no-install-recommends -y python$python_ver python$python_ver-dev python$python_ver-distutils python3-requests python3-pip && rm -rf /var/lib/apt/lists/*;

RUN ln -sfn /usr/bin/python$python_ver /usr/bin/python3 && \
    ln -sfn /usr/bin/python3 /usr/bin/python && \
    ln -sfn /usr/bin/pip3 /usr/bin/pip

RUN pip install --no-cache-dir --upgrade setuptools==59.5.0

RUN git clone -b $graphite_branch --depth 1 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web && \
    git clone -b $graphouse_branch --depth 1 https://github.com/yandex/graphouse.git /usr/local/src/graphouse

WORKDIR /usr/local/src/graphite-web

RUN pip3 install --no-cache-dir -r requirements.txt psycopg2 tornado gevent eventlet
RUN python3 ./setup.py install

WORKDIR /opt/graphite/webapp
RUN mkdir -p /var/log/graphite/ && \
    PYTHONPATH=/opt/graphite/webapp django-admin.py collectstatic --noinput --settings=graphite.settings && \
    PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb

RUN cp /usr/local/src/graphouse/src/main/pySources/graphouse.py /opt/graphite/webapp/graphite/graphouse.py && \
    rm /etc/nginx/sites-enabled/default && \
    cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
ADD src/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD src/nginx-graphite-web.conf /etc/nginx/sites-enabled/graphite-web.conf
ADD src/uwsgi-graphite-web.ini /etc/uwsgi/apps-enabled/graphite-web.ini

ADD src/run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

WORKDIR /opt/graphite/webapp

EXPOSE 80

CMD ["bash","/usr/local/bin/run.sh"]
