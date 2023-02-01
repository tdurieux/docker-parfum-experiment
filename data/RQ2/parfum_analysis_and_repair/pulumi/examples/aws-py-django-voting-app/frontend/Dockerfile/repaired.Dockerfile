FROM ubuntu:18.04

WORKDIR /

EXPOSE 80

RUN apt-get update && \
    apt install --no-install-recommends -y gcc python3-dev python3-pip mysql-client-core-5.7 libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;

ADD requirements.txt /

RUN pip3 install --no-cache-dir -r requirements.txt

ADD mysite /mysite

CMD [ "python3", "/mysite/manage.py", "runserver", "0.0.0.0:80" ]
