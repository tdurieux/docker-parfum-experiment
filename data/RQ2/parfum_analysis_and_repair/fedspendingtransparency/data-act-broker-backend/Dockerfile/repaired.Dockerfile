FROM python:3.7.10

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y netcat-openbsd && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir unittest-xml-reporting setuptools==57.5.0

COPY requirements.txt /data-act/backend/requirements.txt
COPY server_requirements.txt /data-act/backend/server_requirements.txt

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /data-act/backend/requirements.txt --use-feature=2020-resolver
RUN pip install --no-cache-dir -r /data-act/backend/server_requirements.txt

ENV PYTHONPATH /data-act/backend
WORKDIR /data-act/backend

VOLUME /data-act/backend
ADD . /data-act/backend

CMD /bin/sh
