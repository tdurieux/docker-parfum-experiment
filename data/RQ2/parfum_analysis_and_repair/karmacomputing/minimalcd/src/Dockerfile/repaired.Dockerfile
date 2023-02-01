FROM python:3.10-alpine

WORKDIR /usr/src/app
RUN pip install --no-cache-dir --upgrade pip
RUN apk add --update --no-cache build-base \
    libffi-dev openssl-dev bash git gcc sqlite \
    curl

COPY . /usr/src/app/minimalcd/
WORKDIR /usr/src/app/minimalcd/

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir uwsgi
RUN export FLASK_APP=minimalcd;
EXPOSE 80
ENTRYPOINT [ "./entrypoint.sh" ]