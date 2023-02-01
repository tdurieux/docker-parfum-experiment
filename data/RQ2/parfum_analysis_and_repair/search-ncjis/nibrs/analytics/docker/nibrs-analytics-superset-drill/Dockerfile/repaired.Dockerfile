FROM python:3

WORKDIR /

RUN apt-get update && apt-get -y --no-install-recommends install build-essential libssl-dev libffi-dev python-dev python-pip libsasl2-dev libldap2-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade setuptools pip
#RUN pip install superset
RUN pip uninstall -y pandas && pip install --no-cache-dir pandas==0.23.4
RUN pip uninstall -y sqlalchemy && pip install --no-cache-dir sqlalchemy==1.2.18

RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN cd /tmp && git clone https://github.com/cgivre/incubator-superset.git

RUN cd /tmp/incubator-superset && \
  git checkout apache_drill && \
  cd superset/assets/ && \
  npm ci && \
  npm run build && \
  cd ../.. && \
  pip install --no-cache-dir -r requirements.txt && \
  pip install --no-cache-dir -r requirements-dev.txt && \
  pip install --no-cache-dir -e .

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
