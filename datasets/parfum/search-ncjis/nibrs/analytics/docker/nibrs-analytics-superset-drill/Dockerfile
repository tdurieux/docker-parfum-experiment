FROM python:3

WORKDIR /

RUN apt-get update && apt-get -y install build-essential libssl-dev libffi-dev python-dev python-pip libsasl2-dev libldap2-dev
RUN pip install --upgrade setuptools pip
#RUN pip install superset
RUN pip uninstall -y pandas && pip install pandas==0.23.4 # https://github.com/apache/incubator-superset/issues/6770
RUN pip uninstall -y sqlalchemy && pip install sqlalchemy==1.2.18 # https://github.com/apache/incubator-superset/issues/6977

RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

RUN cd /tmp && git clone https://github.com/cgivre/incubator-superset.git

RUN cd /tmp/incubator-superset && \
  git checkout apache_drill && \
  cd superset/assets/ && \
  npm ci && \
  npm run build && \
  cd ../.. && \
  pip install -r requirements.txt && \
  pip install -r requirements-dev.txt && \
  pip install -e .

RUN fabmanager create-admin --app superset --username admin --password admin --firstname admin --lastname admin --email admin@localhost
RUN superset db upgrade
RUN superset init

RUN cd /tmp && \
  git clone https://github.com/JohnOmernik/sqlalchemy-drill && \
  cd sqlalchemy-drill && \
  python setup.py install && \
  cd .. && \
  rm -rf sqlalchemy-drill

COPY files/drill-datasource.yaml /
RUN superset import_datasources -p /drill-datasource.yaml

WORKDIR /tmp/incubator-superset/superset

CMD flask run -p 8088 -h 0.0.0.0 --with-threads --reload --debugger
