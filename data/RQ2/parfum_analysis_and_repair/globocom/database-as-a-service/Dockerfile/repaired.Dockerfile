FROM python:2.7

ADD . /code
WORKDIR /code

RUN apt-get update && apt-get install -y --no-install-recommends \
	libsasl2-dev \
	python-dev \
	libldap2-dev \
	libssl-dev \
	default-libmysqlclient-dev \
	curl \
 && rm -rf /var/lib/apt/lists/*
RUN sed '/st_mysql_options options;/a unsigned int reconnect;' /usr/include/mysql/mysql.h -i.bkp
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir ipython==5.1.0 \
    && pip install --no-cache-dir ipdb==0.10.1 \
    && pip install --no-cache-dir -r requirements_test.txt

ENTRYPOINT /code/tests.sh